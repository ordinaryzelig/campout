require 'spec_helper'

describe MovieSource do

  it '#== compares type and external_id' do
    a = Fandango::MovieSource.new external_id: 1
    b = Fandango::MovieSource.new external_id: '1'
    c = MovieTickets::MovieSource.new external_id: 1
    a.must_equal b
    a.wont_equal c
  end

end
