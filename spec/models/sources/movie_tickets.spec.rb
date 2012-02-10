require 'spec_helper'

describe MovieTickets do

  it_must_behave_like_ticket_source

  it '.find_theaters_near calls MovieTickets::TheaterListing.scour' do
    MovieTickets::TheaterListing.expects(:scour)
    MovieTickets.find_theaters_near(1)
  end

end
