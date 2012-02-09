# Scouring a movie will return array of theaters showing that movie.

class Movie < ActiveRecord::Base

  has_many :movie_sources
  has_many :movie_assignments
  has_many :trackers, through: :movie_assignments

  validates :title,       presence: true
  validates :released_on, presence: true

  scope :unreleased, proc { where('released_on > ?', Date.today) }

  class << self

    # Check for tickets for unreleased movies.
    def check_for_newly_released_tickets
      unreleased.map(&:check_for_tickets).flatten
    end

  end

  # Gather all live trackers.
  # Group them by twitter account.
  # For each twitter account, find theaters selling ticktes for this movie at twitter account's zipcode.
  # For theaters that are selling tickets and match tracker's theater, notify account and close corresponding tracker.
  # Return accounts notified.
  def check_for_tickets
    live_trackers = trackers.live.includes(:twitter_account, :theater).all
    live_trackers.group_by(&:twitter_account).each_with_object([]) do |(twitter_account, trackers), accounts_notified|
      theaters_selling = find_theaters_selling_at(twitter_account.zipcode)
      trackers_to_notify = trackers.select { |tracker| theaters_selling.include?(tracker.theater) }
      if trackers_to_notify.any?
        twitter_account.notify_about_tickets!(trackers_to_notify)
        accounts_notified << twitter_account
      end
    end
  end

  # For each movie_source, find_theaters_selling_at zipcode.
  # Return uniq list of theaters.
  def find_theaters_selling_at(zipcode)
    movie_sources.map do |movie_source|
      movie_source.find_theaters_selling_at(zipcode)
    end.flatten.uniq
  end

end
