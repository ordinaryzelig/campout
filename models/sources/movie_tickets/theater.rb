# Scouring a theater will return array of movies showing at that theater.

class MovieTicketsTheater < ActiveRecord::Base

  has_many :movie_tickets_theater_assignments
  has_many :twitter_accounts, through: :movie_tickets_theater_assignments

  before_validation :create_short_name

  validates :name,       presence: true
  validates :short_name, presence: true
  validates :house_id,   numericality: {greater_than: 0}, uniqueness: true

  scope :tracked_by_multiples, select('movie_tickets_theaters.*, COUNT(movie_tickets_theater_assignments.id) as assignments').
                               joins(:movie_tickets_theater_assignments).
                               group('movie_tickets_theaters.id').
                               having('assignments > 1')

  include HTTParty
  base_uri 'http://www.movietickets.com/house_detail.asp'

  class << self

    # Check to see if movies are parsing correctly.
    def diagnostics
      theater = MovieTicketsTheater.first
      movies = scour theater: theater
      raise "No movies found at #{theater.name}" if movies.empty?
      movies
    end

    # Make request, parse, return movies.
    def scour(options)
      html = get '', query: query_options(options)
      parse html
    end

    private

    # Parse HTML into attributes and return Movie objects.
    def parse(html)
      doc = Nokogiri.HTML(html)
      movies = doc.css('#rw3 li').map do |li|
        # parse.
        title = li.css('h4 a').text
        # Skip if no title.
        next nil if title.blank?
        movie_id = li.css('h4 a').first['href'].match(/movie_id=(?<id>\d+)/)[:id]
        # Build new movie.
        movie = MovieTicketsMovie.new(
          title: title,
          movie_id: movie_id,
        )
      end
      movies.compact
    end

    # Construct options to use in HTTParty request query (i.e.g the ? part).
    # Options (required unless noted otherwise):
    #   theater: Converts to house_id
    #   date (optional)
    def query_options(options)
      options.each_with_object({}) do |(key, val), hash|
        case key
        when :date    then hash[:rdate]    = val.strftime('%D')
        when :theater then hash[:house_id] = val.house_id
        else
          raise "unknown option: #{key}"
        end
      end
    end

  end

  # Find in DB if it exists or save!
  def find_or_create!
    from_db = self.class.find_by_house_id self.house_id
    return from_db if from_db
    save!
    self
  end

  # Theaters should be compared by house_id
  def ==(another_theater)
    self.house_id == another_theater.house_id
  end

  private

  # Remove extraneous 'theater', 'theatre', 'cinema' (or any plural form), and trailing numbers.
  # I don't care how many screens you have.
  # Got limited tweet characters here, people.
  def create_short_name
    self.short_name = name.gsub(/\b(cinema|theater|theatre)s?\b/i, ''). # remove theater, theatre
                           sub(/\d+$/, ''). # remove trailing digits
                           strip.           # remove extraneous white space
                           gsub(/ \s*/, ' ')  # replace multiple whitespaces with single space
  end

end
