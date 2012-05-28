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

    it 'marks an account as blocked if blocked exception caught' do
      exception = Twitter::Error::Forbidden.new('blocked', {})
      Twitter.stubs(:follow).raises(exception)
      FactoryGirl.create(:redningja, followed: false)
      TwitterAccount.any_instance.expects(:blocked!)
      TwitterAccount.follow_all_not_followed
    end

  end

  it '.promptable_for_postal_code scopes for TwitterAccounts that have not beem prompted for postal_code' do
    account = FactoryGirl.create(:redningja, followed: true, prompted_for_postal_code_at: nil)
    TwitterAccount.promptable_for_postal_code.count.must_equal 1
    account.update_attribute :prompted_for_postal_code_at, Time.now
    TwitterAccount.promptable_for_postal_code.count.must_equal 0
  end

  describe '.prompt_for_postal_codes' do

    it 'sends DMs to users who have not yet been prompted for their postal_code and marks them as prompted' do
      FactoryGirl.create(:redningja, followed: true, prompted_for_postal_code_at: nil)
      TwitterAccount.any_instance.expects(:prompt_for_postal_code)
      TwitterAccount.prompt_for_postal_codes
    end

    it 'returns accounts prompted' do
      account = FactoryGirl.build(:redningja)
      TwitterAccount.expects(:promptable_for_postal_code).returns([account])
      account.expects(:prompt_for_postal_code)
      accounts = TwitterAccount.prompt_for_postal_codes
      accounts.must_equal [account]
    end

  end

  it '#prompt_for_postal_code DMs account asking for postal_code and updates account prompted_for_postal_code_at' do
    Timecop.freeze do
      account = FactoryGirl.create(:redningja, prompted_for_postal_code_at: nil)
      PromptForPostalCodeTweet.expects(:new)
      account.expects(:dm!)
      account.prompt_for_postal_code
      account.reload.prompted_for_postal_code_at.must_equal Time.now
    end
  end

  it '#find_theaters_and_confirm_or_deny_location searches for theaters from each ticket source' do
      account = FactoryGirl.build('redningja', postal_code: 73142)
      TicketSources::Scope.any_instance.expects(:find_theaters_near).returns([])
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
    account = FactoryGirl.build(:redningja, postal_code: 10000)
    DenyTheatersTrackedTweet.expects(:new).with(account.postal_code)
    account.expects(:dm!)
    account.deny_theater_list
  end

  it '#deny_postal_code sends DM asking for valid postal_code' do
    account = FactoryGirl.build(:redningja, postal_code: '1')
    InvalidatePostalCodeTweet.expects(:new)
    account.expects(:dm!)
    account.deny_postal_code
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

  describe '.process_DMs_for_postal_codes' do

    it 'extracts postal_code from DM, deletes DM, and processes postal_codes' do
      VCR.use_cassette('twitter/list_DMs_with_redningja_postal_code') do
        stub_geocoder nil, nil, 'US', 73142
        FactoryGirl.create(:redningja, postal_code: nil)
        TwitterAccount.any_instance.expects(:process_postal_code)
        Twitter::DirectMessage.any_instance.expects(:destroy)
        TwitterAccount.process_DMs_for_postal_codes
      end
    end

    it 'sends DM denying postal_code if postal_code cannot be extracted' do
      VCR.use_cassette('twitter/list_DMs_with_bad_postal_codes') do
        stub_empty_geocoder
        FactoryGirl.create(:redningja, postal_code: nil)
        TwitterAccount.any_instance.expects(:deny_postal_code)
        TwitterAccount.any_instance.expects(:process_postal_code).never
        TwitterAccount.process_DMs_for_postal_codes
      end
    end

  end

  describe '#process_postal_code' do

    it 'assigns postal_code and calls #find_theaters_and_confirm_or_deny_location' do
      stub_geocoder nil, nil, 'US', 73142
      account = FactoryGirl.build(:redningja, postal_code: nil)
      account.expects(:find_theaters_and_confirm_or_deny_location)
      account.process_postal_code(73142)
    end

    it 'does nothing if postal_code not different' do
      stub_empty_geocoder
      account = FactoryGirl.create(:redningja, postal_code: '73142')
      account.expects(:find_theaters_and_confirm_or_deny_location).never
      account.process_postal_code(account.postal_code)
    end

    it 'sends DM if country code is not supported' do
      stub_geocoder nil, nil, 'XY', nil
      account = FactoryGirl.build(:redningja, postal_code: nil)
      account.expects(:send_unsupported_country_message)
      account.process_postal_code('123')
    end

  end

  it '#theaters_not_tracking_for_movie returns theaters that account has already been notified about' do
    ticket_notification = FactoryGirl.create(:ticket_notification)
    account = ticket_notification.twitter_account
    account.theaters_not_tracking_for_movie(ticket_notification.movie).must_equal [ticket_notification.theater]
  end

  it '#geocode_with_country_code assigns coordinates and country' do
    VCR.use_cassette 'geocoder/73142' do
      account = FactoryGirl.build(:redningja, postal_code: 73142, country_code: nil, latitude: nil, longitude: nil)
      account.geocode_with_country_code
      account.coordinates.must_equal [35.6131551, -97.6385368]
      account.country_code.must_equal 'US'
    end
  end

  it '#send_unsupported_country_message DMs twitter account saying country code is not supported' do
    account = FactoryGirl.build(:redningja)
    UnsupportedCountryTweet.expects(:new).with(account.country_code)
    account.expects(:dm!)
    account.send_unsupported_country_message
  end

  specify '#blocked! marks an account as blocked' do
    account = FactoryGirl.create(:redningja, blocked: false)
    account.blocked!
    account.blocked.must_equal true
  end

end
