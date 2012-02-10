require 'spec_helper'

describe TicketNotification do

  let(:theater_source) { Fandango::Theater.new(name: 'amc', external_id: 'asdf') }

  it '#theater_source= assigns theater_source_type and external_id' do
    note = TicketNotification.new(theater_source: theater_source)
    note.theater_source_type.must_equal 'Fandango'
    note.external_id.must_equal 'asdf'
  end

  it 'validates inclusion of theater_source_type in TicketSource classes' do
    note = TicketNotification.new(theater_source_type: Fandango.name)
    note.valid?
    note.errors[:theater_source_type].must_be_empty
  end

  it '#theater_source instantiates a new theater source object based on theater_source_type and external_id' do
    note = TicketNotification.new(theater_source: theater_source)
    note.theater_source.must_equal theater_source
  end

end
