require 'spec_helper'

describe TwitterAccount do

  describe '.create_from_followers' do

    it 'creates new accounts from new followers' do
      VCR.use_cassette('twitter/list_followers') do
        new_follower_ids.size.must_equal 1
        TwitterAccount.create_from_followers
        new_follower_ids.size.must_equal 0
      end
    end

    it 'returns new accounts' do
      VCR.use_cassette('twitter/list_followers') do
        accounts = TwitterAccount.create_from_followers
        accounts.size.must_equal 1
        accounts.first.must_be_kind_of TwitterAccount
      end
    end

  end

  describe '.follow_all_not_followed' do

    it 'submits follow requests for any twitter accounts that are not currently followed' do
      VCR.use_cassette('twitter/follow_redningja') do
        FactoryGirl.create(:redningja, followed: false)
        TwitterAccount.followed(false).count.must_equal 1
        TwitterAccount.follow_all_not_followed
        TwitterAccount.followed(false).count.must_equal 0
      end
    end

    it 'returns accounts now followed' do
      VCR.use_cassette('twitter/follow_redningja') do
        FactoryGirl.create(:redningja, followed: false)
        accounts = TwitterAccount.follow_all_not_followed
        accounts.size.must_equal 1
        accounts.first.must_be_kind_of TwitterAccount
      end
    end

  end

  describe '.prompt_for_zipcodes' do

    it 'sends DMs to users who have not yet been prompted for their zipcode and marks them as prompted' do
      VCR.use_cassette('twitter/DM_redningja_prompting_for_zipcode') do
        redningja = FactoryGirl.create(:redningja, followed: true, prompted_for_zipcode_at: nil)
        TwitterAccount.promptable_for_zipcode.count.must_equal 1
        TwitterAccount.prompt_for_zipcodes
        redningja.reload.prompted_for_zipcode_at.wont_be_nil
        TwitterAccount.promptable_for_zipcode.count.must_equal 0
      end
    end

    it 'returns accounts prompted' do
      VCR.use_cassette('twitter/DM_redningja_prompting_for_zipcode') do
        FactoryGirl.create(:redningja, followed: true, prompted_for_zipcode_at: nil)
        accounts = TwitterAccount.prompt_for_zipcodes
        accounts.size.must_equal 1
        accounts.first.must_be_kind_of TwitterAccount
      end

    end

  end

  describe '#find_and_assign_theaters' do

    it 'searches for theaters, creates theaters, and assigns them to twitter account' do
      VCR.use_cassette('movie_tickets/theaters/search_location_73142') do
        account = FactoryGirl.create('redningja', zipcode: 73142)
        account.find_and_assign_theaters
        account_theaters = account.reload.theaters
        account_theaters.map(&:id).must_equal Theater.all.map(&:id)
      end
    end

    it 'clears existing theaters when assigning new ones' do
      VCR.use_cassette('movie_tickets/theaters/search_location_73142') do
        theaters = [FactoryGirl.create(:amc)]
        account = FactoryGirl.create(:redningja, zipcode: 73142, theaters: theaters)
        assignment = account.theater_assignments.first
        account.find_and_assign_theaters
        TheaterAssignment.exists?(assignment.id).must_equal false
      end
    end

  end

  it '#confirm_location_with_theater_list sends DM with closest theater and instructions to change' do
    VCR.use_cassette('twitter/DM_redningja_confirming_theater_list') do
      theaters = [FactoryGirl.create(:amc)]
      account = FactoryGirl.create(:redningja, theaters: theaters)
      account.send(:confirm_location_with_theater_list).must_equal true
    end
  end

  it '#deny_theater_list sends DM with message that no theaters were found' do
    VCR.use_cassette('twitter/DM_redningja_denying_theater_list') do
      account = FactoryGirl.create(:redningja, zipcode: 10000)
      account.send(:deny_theater_list).must_equal true
    end
  end

  it '#deny_zipcode sends DM asking for valid zipcode' do
    VCR.use_cassette('twitter/DM_redningja_denying_zipcode') do
      account = FactoryGirl.create(:redningja)
      account.deny_zipcode.must_equal true
    end
  end

  describe '#notify_about_tickets!' do

    let(:movie)    { FactoryGirl.create(:iron_lady) }
    let(:theaters) { [:amc, :warren].map { |t| FactoryGirl.create(t) } }
    let(:account)  { FactoryGirl.create(:redningja, movies: [movie], theaters: theaters) }

    it 'DMs account with list of theaters selling tickets' do
      account.must_expect_to_send_DM('The Iron Lady is on sale at AMC Quail Springs Mall, Moore Warren')
      account.notify_about_tickets!(account.trackers)
    end

  end

  it '#dm! wraps message in TweetString' do
    message = 'f' * (TweetString::CHARACTER_LIMIT + 1)
    proc { TwitterAccount.new.send(:dm!, message) }.must_raise TweetString::LimitExceeded
  end

  describe '.process_DMs_for_zipcodes' do

    it 'extracts zipcode from DM and finds/assigns theaters' do
      VCR.use_cassette('twitter/list_DMs_and_deletes_DM_from_redningja') do
        account = FactoryGirl.create(:redningja, zipcode: nil)
        TwitterAccount.any_instance.expects(:find_and_assign_theaters)
        TwitterAccount.any_instance.expects(:confirm_or_deny_theaters)
        Twitter::DirectMessage.any_instance.expects(:destroy)
        TwitterAccount.process_DMs_for_zipcodes
        account.reload.zipcode.must_equal '73142'
      end
    end

    it 'sends DM denying zipcode if zipcode cannot be extracted' do
      VCR.use_cassette('twitter/list_DMs_with_bad_zipcodes') do
        FactoryGirl.create(:redningja)
        TwitterAccount.any_instance.expects(:deny_zipcode)
        TwitterAccount.process_DMs_for_zipcodes
      end
    end

    it 'does not find or assign theaters if zipcode has not changed' do
      VCR.use_cassette('twitter/list_DMs_and_deletes_DM_from_redningja') do
        FactoryGirl.create(:redningja, zipcode: 73142)
        TwitterAccount.any_instance.expects(:find_and_assign_theaters).never
        TwitterAccount.process_DMs_for_zipcodes
      end
    end

  end

  describe '.confirm_or_deny_theaters' do

    it 'confirms location with theater list if theaters found' do
      account = FactoryGirl.build(:redningja)
      account.expects(:theaters).returns([1])
      account.expects(:confirm_location_with_theater_list)
      account.confirm_or_deny_theaters
    end

    it 'denies theater list if no theaters found' do
      account = FactoryGirl.build(:redningja)
      account.expects(:deny_theater_list)
      account.confirm_or_deny_theaters
    end

  end

end
