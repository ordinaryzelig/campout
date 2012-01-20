class MovieTicketsTracker < ActiveRecord::Base

  belongs_to :twitter_account
  belongs_to :movie_tickets_movie_assignment
  belongs_to :movie_tickets_theater_assignment
  has_one    :movie_tickets_movie,   through: :movie_tickets_movie_assignment
  has_one    :movie_tickets_theater, through: :movie_tickets_theater_assignment

  validates :twitter_account_id,                  presence: true
  validates :movie_tickets_movie_assignment_id,   presence: true
  validates :movie_tickets_theater_assignment_id, presence: true

end
