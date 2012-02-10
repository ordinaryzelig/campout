require 'spec_helper'

describe TicketSources do

  it '.all returns each ticket source class' do
    TicketSources.all.must_equal [Fandango, MovieTickets]
  end

  it '.find_theaters_near calls .find_theaters_near on each theater source' do
    zipcode = 1
    TicketSources.all.each { |source| source.expects(:find_theaters_near).with(zipcode) }
    TicketSources.find_theaters_near(zipcode)
  end

end
