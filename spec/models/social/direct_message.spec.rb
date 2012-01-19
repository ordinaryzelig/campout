require 'spec_helper'

describe Twitter::DirectMessage do

  it '#twitter_account finds TwitterAccount from sender data' do
    VCR.use_cassette('twitter/list_DMs') do
      redningja = FactoryGirl.create(:redningja)
      dm = Twitter.direct_messages.first
      dm.twitter_account.must_equal(redningja)
    end
  end

  describe '#process_zipcode' do

    it 'lists DMs, extracts zipcode, assigns zipcode to twitter account, attempts to find and assign theaters, deletes DM' do
      VCR.use_cassette('twitter/list_DMs_and_deletes_DM_from_redningja') do
        FactoryGirl.create(:redningja, zipcode: nil)
        dm = Twitter.direct_messages.first
        dm.expects(:destroy)
        dm.twitter_account.expects(:find_and_assign_theaters)
        dm.process_zipcode
        dm.twitter_account.zipcode.must_equal 73142
      end
    end

    it 'denyies zipcode if cannot be extracted' do
      VCR.use_cassette('twitter/list_DMs_with_bad_zipcodes') do
        FactoryGirl.create(:redningja)
        dm = Twitter.direct_messages.first
        account = dm.twitter_account
        account.expects(:deny_zipcode)
        dm.process_zipcode
      end
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
