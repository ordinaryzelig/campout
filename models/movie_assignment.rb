class MovieAssignment < ActiveRecord::Base

  belongs_to :movie
  belongs_to :twitter_account
  include HasManyTrackers

  validates :movie_id, presence: true
  validates :twitter_account_id, presence: true

  private

  # Create trackers for each theater assignment.
  def create_trackers
    twitter_account.theater_assignments.each do |theater_assignment|
      trackers.create!(
        twitter_account:       twitter_account,
        theater_assignment_id: theater_assignment.id,
      )
    end
  end

end
