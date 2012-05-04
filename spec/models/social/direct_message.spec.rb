require 'spec_helper'

describe Twitter::DirectMessage do

  it '#twitter_account finds TwitterAccount from sender data' do
    VCR.use_cassette('twitter/list_DMs') do
      redningja = FactoryGirl.create(:redningja)
      dm = Twitter.direct_messages.first
      dm.twitter_account.must_equal(redningja)
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
