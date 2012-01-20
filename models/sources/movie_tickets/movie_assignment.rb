class MovieTicketsMovieAssignment < ActiveRecord::Base

  belongs_to :movie_tickets_movie
  belongs_to :twitter_account

  validates :movie_tickets_movie_id, presence: true
  validates :twitter_account_id, presence: true

end
