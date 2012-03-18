require 'spec_helper'

describe 'Twitter workflow' do

  scenario 'when user follows @TDKRcampout' do
    it 'Twitter client gathers list of followers and creates a TwitterAccount for each' do
      VCR.use_cassette('twitter/list_followers') do
        TwitterAccount.create_from_followers
        TwitterAccount.count.must_equal 1
      end
    end
  end

  scenario 'after TwitterAccount created' do
    it '@TDKRcampout follows account back' do
      VCR.use_cassette('twitter/follow_redningja') do
        account = FactoryGirl.create(:redningja, followed: false)
        TwitterAccount.follow_all_not_followed
        account.reload.followed.must_equal true
      end
    end
  end

  scenario 'after TwitterAccount followed' do
    it '@TDKRcampout asks for postal code' do
      VCR.use_cassette('twitter/DM_redningja_prompting_for_postal_code') do
        Timecop.freeze(Time.now) do
          account = FactoryGirl.create(:redningja, followed: true, prompted_for_postal_code_at: nil)
          TwitterAccount.prompt_for_postal_codes
          account.reload.prompted_for_postal_code_at.must_equal Time.now
        end
      end
    end
  end

  scenario 'after prompted for postal code' do

    scenario 'user replies with DM with valid postal code' do
      it 'Twitter client processes DMs with postal codes, assigns postal code to user, DMs user with list of theaters that will be tracked, and deletes DM' do
        VCR.use_cassette 'twitter/list_DMs_with_redningja_postal_code' do
          account = FactoryGirl.create(:redningja, postal_code: nil)
          TwitterAccount.any_instance.expects(:process_postal_code)
          Twitter::DirectMessage.any_instance.expects(:destroy)
          TwitterAccount.process_DMs_for_postal_codes
        end
      end
    end

    scenario 'user replies with DM with invalid postal code' do
      it 'Twitter client DMs user saying postal code not recognized' do
        VCR.use_cassette 'twitter/list_DMs_with_bad_postal_codes' do
          account = FactoryGirl.create(:redningja, postal_code: nil)
          InvalidatePostalCodeTweet.expects(:new)
          TwitterAccount.any_instance.expects(:dm!)
          TwitterAccount.process_DMs_for_postal_codes
        end
      end
    end

    scenario 'user replies with DM with postal code, but no theaters found' do
      it 'Twitter client DMs user saying no theaters found and instructions to send another postal code' do
        VCR.use_cassette 'twitter/list_DMs_with_postal_codes_with_no_theaters' do
          disable_geocoding
          account = FactoryGirl.create(:redningja)
          TicketSources.expects(:find_theaters_near).returns([])
          DenyTheatersTrackedTweet.expects(:new)
          TwitterAccount.any_instance.expects(:dm!)
          TwitterAccount.process_DMs_for_postal_codes
        end
      end
    end

  end

  scenario 'when tickets found at theater' do
    it 'Twitter client DMs user with list of theaters selling tickets' do
      date_test_run = Date.civil(2012, 1, 20)
      Timecop.freeze(date_test_run) do
        VCR.use_cassette 'movie_tickets/movies/ghost_rider' do
          # Lots of setup.
          movie = FactoryGirl.create(:movie_tickets_ghost_rider).movie
          disable_geocoding
          FactoryGirl.create(:redningja, movies: [movie], postal_code: 10001)
          theater_source = FactoryGirl.create(:movie_tickets_amc)
          theater = theater_source.theater
          TicketSources.expects(:find_theaters_selling_at).returns([theater])
          TicketsOnSaleTweet.expects(:new)
          TwitterAccount.any_instance.expects(:dm!)
          # The actual call.
          Movie.check_for_newly_released_tickets
          TicketNotification.count.must_equal 1
        end
      end
    end
  end

end
