# Scouring a movie will return array of theaters showing that movie.

class MovieTicketsMovie < ActiveRecord::Base

  has_many :movie_tickets_movie_assignments
  has_many :movie_tickets_trackers, through: :movie_tickets_movie_assignments

  validates :movie_id,    presence: true, uniqueness: true
  validates :title,       presence: true
  validates :released_on, presence: true

  scope :unreleased, proc { where('released_on > ?', Date.today) }

  include HTTParty
  base_uri 'http://www.movietickets.com/movie_detail.asp'

  class << self

    # Check for tickets for unreleased movies.
    def check_for_newly_released_tickets
      unreleased.map(&:check_for_tickets).flatten
    end

    # Check to see if theaters are parsing correctly.
    def diagnostics(movie)
      theaters = scour(movie: movie, zipcode: 73142)
      raise "No theaters found for #{movie.title}" if theaters.empty?
      theaters
    end

    # Make request, parse, return theaters.
    def scour(options)
      html = get '', query: query_options(options)
      parse html
    end

    private

    # Parse HTML into attributes and return Theater objects.
    def parse(html)
      doc = Nokogiri.HTML(html)
      theaters = doc.css('#mdRow1 li').map do |li|
        name = li.css('a strong').text
        next if name.blank?
        house_id = li.css('a').first['href'].match(/house_id=(?<id>\d+)/)[:id]
        MovieTicketsTheater.new(
          name: name,
          house_id: house_id,
        )
      end.compact
      theaters
    end

    # Construct options to use in HTTParty request query (i.e.g the ? part).
    # Options:
    #   zipcode
    #   movie: Converts to movie_id and ShowDate.
    def query_options(options)
      options.each_with_object({}) do |(key, val), hash|
        case key
        when :date
          hash[:ShowDate] = val.to_ShowDate
        when :movie
          # Set both movie_id and ShowDate.
          movie = val
          hash[:movie_id]  = movie.movie_id
          hash[:ShowDate]  = movie.released_on.to_ShowDate if movie.released_on
        when :zipcode
          hash[:SearchZip] = val
        else
          raise "unknown option: #{key}"
        end
      end
    end

  end

  def find_theaters_selling_at(zipcode)
    self.class.scour(
      movie:   self,
      zipcode: zipcode,
    )
  end

  # Gather all live trackers.
  # Group them by twitter account.
  # find theaters selling at twitter account's zipcode.
  # For theaters that are selling tickets now, notify account and close corresponding tracker.
  # Return accounts notified.
  def check_for_tickets
    live_trackers = movie_tickets_trackers.live.includes(:twitter_account, :movie_tickets_theater).all
    live_trackers.group_by(&:twitter_account).each_with_object([]) do |(twitter_account, trackers), accounts_notified|
      theaters = find_theaters_selling_at(twitter_account.zipcode)
      trackers_to_notify = trackers.select { |tracker| theaters.include?(tracker.movie_tickets_theater) }
      if trackers_to_notify.any?
        twitter_account.notify_about_tickets!(trackers_to_notify)
        accounts_notified << twitter_account
      end
    end
  end

end
