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

  it '.promptable_for_zipcode scopes for TwitterAccounts that have not beem prompted for zipcode' do
    account = FactoryGirl.create(:redningja, followed: true, prompted_for_zipcode_at: nil)
    TwitterAccount.promptable_for_zipcode.count.must_equal 1
    account.update_attribute :prompted_for_zipcode_at, Time.now
    TwitterAccount.promptable_for_zipcode.count.must_equal 0
  end

  describe '.prompt_for_zipcodes' do

    it 'sends DMs to users who have not yet been prompted for their zipcode and marks them as prompted' do
      FactoryGirl.create(:redningja, followed: true, prompted_for_zipcode_at: nil)
      TwitterAccount.any_instance.expects(:prompt_for_zipcode)
      TwitterAccount.prompt_for_zipcodes
    end

    it 'returns accounts prompted' do
      account = FactoryGirl.build(:redningja)
      TwitterAccount.expects(:promptable_for_zipcode).returns([account])
      account.expects(:prompt_for_zipcode)
      accounts = TwitterAccount.prompt_for_zipcodes
      accounts.must_equal [account]
    end

  end

  it '#prompt_for_zipcode DMs account asking for zipcode and updates account prompted_for_zipcode_at' do
    Timecop.freeze do
      account = FactoryGirl.create(:redningja, prompted_for_zipcode_at: nil)
      PromptForPostalCodeTweet.expects(:new)
      account.expects(:dm!)
      account.prompt_for_zipcode
      account.reload.prompted_for_zipcode_at.must_equal Time.now
    end
  end

  it '#find_theaters_and_confirm_or_deny_location searches for theaters from each ticket source' do
      account = FactoryGirl.build('redningja', zipcode: 73142)
      TicketSources.expects(:find_theaters_near).returns([])
      account.expects(:dm!)
      account.find_theaters_and_confirm_or_deny_location
  end

  it '#confirm_location_with sends DM with closest theater and instructions to change' do
    account = FactoryGirl.build(:redningja)
    theaters = [Theater.new(name: '')]
    ConfirmTheatersTrackedTweet.expects(:new).with(theaters)
    account.expects(:dm!)
    account.confirm_location_with(theaters)
  end

  it '#deny_theater_list sends DM with message that no theaters were found' do
    account = FactoryGirl.build(:redningja, zipcode: 10000)
    DenyTheatersTrackedTweet.expects(:new).with(account.zipcode)
    account.expects(:dm!)
    account.deny_theater_list
  end

  it '#deny_zipcode sends DM asking for valid zipcode' do
    account = FactoryGirl.build(:redningja, zipcode: '1')
    DenyLocationTweet.expects(:new)
    account.expects(:dm!)
    account.deny_zipcode
  end

  describe '#notify_about_tickets!' do

    let(:movie)   { FactoryGirl.build(:iron_lady) }
    let(:theater) { FactoryGirl.build(:amc) }
    let(:account) { FactoryGirl.build(:redningja) }

    it 'DMs account with list of theaters selling tickets'do
      TicketNotification.expects(:create!).with(theater: theater)
      account.expects(:dm!)
      account.notify_about_tickets!(movie, [theater])
    end

  end

  it '#dm! wraps message in TweetString, validates the TweetString, and sends DM to Twitter' do
    account = TwitterAccount.new(user_id: 1)
    message = 'asdf'
    TweetString.any_instance.expects(:validate!)
    Twitter.expects(:direct_message_create).with(account.user_id, message)
    account.send :dm!, message
  end

  describe '.process_DMs_for_zipcodes' do

    before { FactoryGirl.create(:redningja, zipcode: nil) }

    it 'extracts zipcode from DM, deletes DM, and processes zipcodes' do
      VCR.use_cassette('twitter/list_DMs_with_redningja_zipcode') do
        TwitterAccount.any_instance.expects(:process_zipcode)
        Twitter::DirectMessage.any_instance.expects(:destroy)
        TwitterAccount.process_DMs_for_zipcodes
      end
    end

    it 'sends DM denying zipcode if zipcode cannot be extracted' do
      VCR.use_cassette('twitter/list_DMs_with_bad_zipcodes') do
        TwitterAccount.any_instance.expects(:deny_zipcode)
        TwitterAccount.process_DMs_for_zipcodes
      end
    end

  end

  describe '#process_zipcode' do

    it 'assigns zipcode and calls #find_theaters_and_confirm_or_deny_location' do
      account = FactoryGirl.build(:redningja, zipcode: nil)
      account.expects(:find_theaters_and_confirm_or_deny_location)
      account.process_zipcode(73142)
    end

    it 'does nothing if zipcode not different' do
      account = FactoryGirl.create(:redningja, zipcode: 73142)
      account.expects(:save).never
      account.expects(:find_theaters_and_confirm_or_deny_location).never
      account.process_zipcode(account.zipcode)
    end

  end

  it '#theaters_not_tracking_for_movie returns theaters that account has already been notified about' do
    ticket_notification = FactoryGirl.create(:ticket_notification)
    account = ticket_notification.twitter_account
    account.theaters_not_tracking_for_movie(ticket_notification.movie).must_equal [ticket_notification.theater]
  end

end
