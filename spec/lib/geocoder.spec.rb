require 'spec_helper'

describe Geocoder do

  it 'raises LimitExceeded, not just warns' do
    require 'geocoder/lookups/google'
    Geocoder::Lookup::Google.any_instance.expects(:fetch_data).returns('status' => 'OVER_QUERY_LIMIT')
    proc { Geocoder.coordinates('asdf') }.must_raise(Geocoder::OverQueryLimitError)
  end

end
