require 'spec_helper'

describe Theater do

  describe '#==' do

    it 'returns true if theaters have same external_id' do
      external_id = 'asdf'
      a = Theater.new(external_id: external_id)
      b = Theater.new(external_id: external_id)
      a.must_equal b
    end

    it 'returns true if address look similar'

  end

end
