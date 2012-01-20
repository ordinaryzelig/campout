class MovieTicketsTracker < ActiveRecord::Base

  belongs_to :movie_tickets_movie
  belongs_to :twitter_account

end
