require 'spec_helper'

describe TwitterAccount do

  it '.create_from_followers creates new accounts from new followers' do
    VCR.use_cassette('twitter/list_followers') do
      new_follower_ids.size.must_equal 1
      TwitterAccount.create_from_followers
      new_follower_ids.size.must_equal 0
    end
  end

  it '.follow_all_not_followed submits follow requests for any twitter accounts that are not currently followed' do
    VCR.use_cassette('twitter/follow_redningja') do
      FactoryGirl.create(:redningja, followed: false)
      TwitterAccount.followed(false).count.must_equal 1
      TwitterAccount.follow_all_not_followed
      TwitterAccount.followed(false).count.must_equal 0
    end
  end

  it '.prompt_for_zipcodes sends DMs to users who have not yet been prompted for their zipcode and marks them as prompted' do
    VCR.use_cassette('twitter/DM_redningja_prompting_for_zipcode') do
      redningja = FactoryGirl.create(:redningja, followed: true, prompted_for_zipcode_at: nil)
      TwitterAccount.promptable_for_zipcode.count.must_equal 1
      TwitterAccount.prompt_for_zipcodes
      redningja.reload.prompted_for_zipcode_at.wont_be_nil
      TwitterAccount.promptable_for_zipcode.count.must_equal 0
    end
  end

  it '.process_DMs_for_zipcodes lists DMs, extracts zipcode, assigns zipcode to twitter account, deletes DM' do
    VCR.use_cassette('twitter/list_DMs_and_deletes_DM_from_redningja') do
      Twitter::DirectMessage.any_instance.expects(:destroy)
      redningja = FactoryGirl.create(:redningja, zipcode: nil)
      TwitterAccount.process_DMs_for_zipcodes
      redningja.reload.zipcode.must_equal 73142
    end
  end

  it '.find_and_assign_theaters searches for theaters, creates theaters, and assigns them to twitter account' do
    VCR.use_cassette('movie_tickets/theaters/search_location_73142') do
      TwitterAccount.any_instance.expects(:confirm_location_with_theater_list)
      account = FactoryGirl.create('redningja', zipcode: 73142)
      TwitterAccount.find_and_assign_theaters
      account_theaters = account.reload.movie_tickets_theaters
      account_theaters.map(&:house_id).must_equal MovieTicketsTheater.all.map(&:house_id)
      account.theaters_assigned.must_equal true
    end
  end

  it '#confirm_location_with_theater_list sends DM with closest theater and instructions to change' do
    VCR.use_cassette('twitter/DM_redningja_confirming_theater_list') do
      theaters = [FactoryGirl.create(:movie_tickets_amc)]
      account = FactoryGirl.create(:redningja, movie_tickets_theaters: theaters)
      account.confirm_location_with_theater_list.must_equal true # Make sure DM was sent.
    end
  end

  it '#deny_location sends DM with message that no theaters were found' do
    VCR.use_cassette('twitter/DM_redningja_denying_theater_list') do
      account = FactoryGirl.create(:redningja, zipcode: 10000)
      account.deny_location.must_equal true
    end
  end

  it '.process_DMs_for_zipcodes handles cases when zipcode cannot be extracted'

end
