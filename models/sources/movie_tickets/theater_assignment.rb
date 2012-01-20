class MovieTicketsTheaterAssignment < ActiveRecord::Base

  belongs_to :movie_tickets_theater
  belongs_to :twitter_account
  include HasManyTrackers

  validates :movie_tickets_theater_id, presence: true
  validates :twitter_account_id, presence: true

  private

  # Create trackers for each movie assignment.
  def create_trackers
    twitter_account.movie_tickets_movie_assignments.each do |movie_assignment|
      movie_tickets_trackers.create!(
        twitter_account:                     twitter_account,
        movie_tickets_movie_assignment_id:   movie_assignment.id,
      )
    end
  end

end
