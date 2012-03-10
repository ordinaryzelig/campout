require 'spec_helper'

describe Geocoder do

  it 'raises LimitExceeded, not just warns' do
    require 'geocoder/lookups/google'
    Geocoder::Lookup::Google.any_instance.expects(:fetch_data).returns('status' => 'OVER_QUERY_LIMIT')
    proc { Geocoder.coordinates('asdf') }.must_raise(Geocoder::OverQueryLimitError)
  end

  describe '.loop_on_query_limit_exception' do

    it 'raises LimitExceeded after looping so many times' do
      process = proc do
        Geocoder.loop_on_query_limit_exception do
          Geocoder::LOOPS_ALLOWED.times do
            raise Geocoder::OverQueryLimitError
          end
        end
      end
      process.must_raise(Geocoder::OverQueryLimitError)
    end

    it 'returns value of yielded block' do
      process = proc do
        Geocoder.loop_on_query_limit_exception do
          42
        end
      end
      process.call.must_equal 42
    end

  end

end
