require 'spec_helper'

describe Fandango do

  describe '.loop_on_bad_request' do

    it 'raises BadRequest after looping so many times' do
      process = proc do
        Fandango.loop_on_bad_response do
          Fandango::LOOPS_ALLOWED.times do
            raise Fandango::BadResponse.new(0)
          end
        end
      end
      process.must_raise(Fandango::BadResponse)
    end

  end

end
