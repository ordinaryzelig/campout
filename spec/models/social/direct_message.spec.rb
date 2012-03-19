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

  it 'validates postal code' do
    VCR.use_cassette('twitter/list_DMs_with_bad_postal_codes') do
      dm = Twitter.direct_messages.first
      PostalCodeTweet.any_instance.expects(:valid?).returns(false)
      dm.extract_postal_code.must_equal nil
    end
  end

  it '#extract_postal_code returns PostalCode object if valid' do
    VCR.use_cassette('twitter/list_DMs') do
      redningja = FactoryGirl.create(:redningja)
      dm = Twitter.direct_messages.first
      postal_code = dm.extract_postal_code
      postal_code.must_be_kind_of PostalCode
      postal_code.must_be :valid?
    end
  end

end
