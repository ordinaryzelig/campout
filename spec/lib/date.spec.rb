require 'spec_helper'

describe Date do

  describe '#to_ShowDate' do

    it 'returns 0 for today' do
      Date.today.to_ShowDate.must_equal 0
    end

    it 'returns 1 for tomorrow i.e. one day from now' do
      Chronic.parse('tomorrow').to_date.to_ShowDate.must_equal 1
    end

    it 'returns 7 for 1 week from now' do
      Chronic.parse('in 1 week').to_date.to_ShowDate.must_equal 7
    end

    it 'returns 0 for past days' do
      Chronic.parse('yesterday').to_date.to_ShowDate.must_equal 0
    end

  end

end
