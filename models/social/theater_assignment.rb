class TheaterAssignment < ActiveRecord::Base

  belongs_to :movie_tickets_theater
  belongs_to :twitter_account

end
