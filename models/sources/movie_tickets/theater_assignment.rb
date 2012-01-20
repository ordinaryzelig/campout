class MovieTicketsTheaterAssignment < ActiveRecord::Base

  belongs_to :movie_tickets_theater
  belongs_to :twitter_account

  validates :movie_tickets_theater_id, presence: true
  validates :twitter_account_id, presence: true

end
