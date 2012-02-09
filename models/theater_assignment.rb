class TheaterAssignment < ActiveRecord::Base

  belongs_to :theater
  belongs_to :twitter_account
  include HasManyTrackers

  validates :theater_id, presence: true
  validates :twitter_account_id, presence: true

  private

  # Create trackers for each movie assignment.
  def create_trackers
    twitter_account.movie_assignments.each do |movie_assignment|
      trackers.create!(
        twitter_account:     twitter_account,
        movie_assignment_id: movie_assignment.id,
      )
    end
  end

end
