require 'spec_helper'

describe Twitter::DirectMessage do

  it '#twitter_account finds TwitterAccount from sender data' do
    VCR.use_cassette('twitter/list_DMs') do
      redningja = FactoryGirl.create(:redningja)
      dm = Twitter.direct_messages.first
      dm.twitter_account.must_equal(redningja)
    end
  end

  it '#extract_zipcode returns zipcode contained in text' do
    VCR.use_cassette('twitter/DMs_from_redningja') do
      dm = Twitter.direct_messages.first
      dm.extract_zipcode.must_equal 73142
    end
  end

  it "#extract_and_assign_zipcode assigns zipcode to sender's twitter account" do
    VCR.use_cassette('twitter/list_DMs') do
      redningja = FactoryGirl.create(:redningja, zipcode:  nil)
      dm = Twitter.direct_messages.first
      dm.extract_and_assign_zipcode!
      redningja.reload.zipcode.must_equal 73142
    end
  end

  it '#destroy sends destroy request to Twitter' do
    VCR.use_cassette('twitter/list_DMs') do
      Twitter.expects(:direct_message_destroy)
      dm = Twitter.direct_messages.first
      dm.destroy
    end
  end

end
