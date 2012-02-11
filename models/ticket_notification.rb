require_relative 'ticket_sources'

# When tickets go on sale for a movie at a certain theater,
# create this object noting that the TwitterAccount has already
# been notified of tickets going on sale here.
# This is to prevent notifying over and over again.
class TicketNotification < ActiveRecord::Base

  belongs_to :twitter_account
  belongs_to :movie
  belongs_to :theater

  validates :twitter_account_id, presence: true
  validates :movie_id, presence: true
  validates :theater_id, presence: true, uniqueness: {scope: [:twitter_account_id, :movie_id]}

  scopes_for_associations

end
