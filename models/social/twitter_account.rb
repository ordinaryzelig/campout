class TwitterAccount < ActiveRecord::Base

  has_many :movie_assignments, dependent: :destroy
  has_many :movies, through: :movie_assignments
  has_many :ticket_notifications, dependent: :destroy

  validates :user_id, presence: true, uniqueness: true
  validates :screen_name, presence: true, uniqueness: true
  validates :followed, inclusion: {in: [true, false]}

  scope :followed, proc { |bool| where(followed: bool) }
  scope :not_prompted_for_zipcode, where(prompted_for_zipcode_at: nil)
  scope :promptable_for_zipcode, followed(true).not_prompted_for_zipcode

  class << self

    # Create new twitter accounts from followers.
    # list followers that are not yet followed.
    # create new twitter account in DB.
    # Return new accounts.
    def create_from_followers
      new_follower_ids.map do |follower_id|
        twitter_user = Twitter.user(follower_id)
        create_from_twitter_user!(twitter_user)
      end
    end

    # Follow back twitter accounts not yet followed.
    # Mark as followed.
    # Return accounts now followed.
    def follow_all_not_followed
      followed(false).map do |twitter_account|
        Twitter.follow(twitter_account.user_id)
        twitter_account.update_attributes! followed: true
        twitter_account
      end
    end

    # Prompt each twitter account that we are following that has not yet been prompted.
    def prompt_for_zipcodes
      promptable_for_zipcode.each &:prompt_for_zipcode
    end

    # List DMs, process each for zipcode.
    # If zipcode successfully extracted, assign to twitter account if different.
    # If zipcode cannot be processed, deny_zipcode.
    # If zipcode extracted
    # If theaters found, DM confirmation.
    # If no theaters found, DM no theaters found.
    # Make sure to only find/assign theaters if zipcode is different
    # so we don't sound like a broken record.
    def process_DMs_for_zipcodes
      Twitter.direct_messages.each do |dm|
        zipcode = dm.extract_zipcode
        dm.destroy
        twitter_account = dm.twitter_account
        if zipcode
          twitter_account.process_zipcode(zipcode)
        else
          twitter_account.deny_zipcode
        end
      end
    end

    private

    def create_from_twitter_user!(twitter_user)
      create!(
        screen_name: twitter_user.screen_name,
        user_id:     twitter_user.id,
        location:    twitter_user.location,
      )
    end

    # follower_ids who we are not yet following.
    def new_follower_ids
      follower_ids - select(:user_id).map(&:user_id)
    end

    # All follwer ids.
    def follower_ids
      cursor = Twitter.follower_ids
      raise "Paginated Cursor?" if cursor.next > 0
      cursor.collection
    end

  end

  # DM with instructions asking for zipcode,
  # mark as prompted.
  def prompt_for_zipcode
    dm! PromptForPostalCodeTweet.new
    update_attributes! prompted_for_zipcode_at: Time.now
  end

  # Using zipcode, find theaters.
  # If theaters found, send DM confirmation, else send DM denial.
  def find_theaters_and_confirm_or_deny_location
    theaters = TicketSources.find_theaters_near(zipcode)
    if theaters.any?
      confirm_location_with theaters
    else
      deny_theater_list
    end
  end

  # Given trackers, DM with movie and trackers' theaters.
  # Close trackers.
  def notify_about_tickets!(movie, theaters)
    TicketNotification.transaction do
      theaters.each do |theater|
        ticket_notifications.for(movie).create!(theater: theater)
      end
    end
    dm! TicketsOnSaleTweet.new(movie, theaters)
  end

  # Send DM with closest theater (should be first) and instructions on how to change.
  def confirm_location_with(theater_listings)
    dm! ConfirmTheatersTrackedTweet.new(theater_listings)
  end

  # Send DM denying any theaters near zipcode.
  def deny_theater_list
    dm! DenyTheatersTrackedTweet.new(zipcode)
  end

  def deny_zipcode
    dm! DenyLocationTweet.new
  end

  # Set zipcode. if different than before, find theaters and confirm/deny location.
  def process_zipcode(zipcode)
    self.zipcode = zipcode
    if zipcode_changed?
      save!
      find_theaters_and_confirm_or_deny_location
    end
  end

  def theaters_not_tracking_for_movie(movie)
    ticket_notifications.for(movie).includes(:theater).map(&:theater)
  end

  private

  # Send a DM with message. Return true if successful.
  # Wrap message in TweetString.
  def dm!(message)
    tweet_string = TweetString.new(message)
    tweet_string.validate!
    Twitter.direct_message_create(self.user_id, tweet_string.to_s)
    true
  end

end
