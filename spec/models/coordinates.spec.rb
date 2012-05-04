require 'spec_helper'

describe Coordinates do

  describe '.from_address' do

    it 'returns coordinates if address recognized' do
      stub_geocoder 1, 2, nil, nil
      Coordinates.from_address('asdf').must_equal [1, 2]
    end

    it 'recursively reduces accuracy of address' do
      long_address = '_eventually_removed_by_recursion_, 73142'
      Geocoder.expects(:search).with(long_address).returns([])
      Geocoder.expects(:search).with('73142').returns([])
      Coordinates.from_address(long_address)
    end

  end

end
