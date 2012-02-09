require 'spec_helper'

describe Theater do

  describe '#short_name' do

    it 'is altered by removing common words and any trailing numbers to save character space' do
      name = 'fancy  schmancy theater theatre theaters  cinema cinemas    cinemark 64'
      theater = Theater.new(name: name)
      theater.valid?
      theater.short_name.must_equal 'fancy schmancy cinemark'
    end

    it 'is the same as name if blank' do
      name = 'cinema 12'
      theater = Theater.new(name: name)
      theater.valid?
      theater.short_name.must_equal name
    end

  end

end
