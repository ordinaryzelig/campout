class MovieAssignment < ActiveRecord::Base

  belongs_to :movie
  belongs_to :twitter_account

  validates :movie_id, presence: true
  validates :twitter_account_id, presence: true

end
