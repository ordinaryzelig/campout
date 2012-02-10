require_relative 'ticket_sources'

# When tickets go on sale for a movie at a certain theater,
# create this object noting that the TwitterAccount has already
# been notified of tickets going on sale here.
# This is to prevent notifying over and over again.
class TicketNotification < ActiveRecord::Base

  belongs_to :twitter_account
  belongs_to :movie

  validates :twitter_account_id, presence: true
  validates :movie_id, presence: true
  validates :theater_source_type, presence: true, inclusion: {in: TicketSources.all.map(&:name)}
  validates :external_id, presence: true

  scopes_for_associations

  def theater_source=(theater_source)
    self.theater_source_type = theater_source.class.type.name
    self.external_id         = theater_source.external_id
  end

  def theater_source
    theater_source_type.constantize::Theater.new(external_id: external_id)
  end
  # Not sure if we're going to differentiate between these right now.
  alias_method :theater, :theater_source

end
