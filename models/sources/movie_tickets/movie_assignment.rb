class MovieTicketsMovieAssignment < ActiveRecord::Base

  belongs_to :movie_tickets_movie
  belongs_to :twitter_account
  include HasManyTrackers

  validates :movie_tickets_movie_id, presence: true
  validates :twitter_account_id, presence: true

  private

  # Create trackers for each theater assignment.
  def create_trackers
    twitter_account.movie_tickets_theater_assignments.each do |theater_assignment|
      movie_tickets_trackers.create!(
        twitter_account:                     twitter_account,
        movie_tickets_theater_assignment_id: theater_assignment.id,
      )
    end
  end

end
