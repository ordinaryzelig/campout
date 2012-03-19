class TwitterAccount < ActiveRecord::Base

  has_many :movie_assignments, dependent: :destroy
  has_many :movies, through: :movie_assignments
  has_many :ticket_notifications, dependent: :destroy

  validates :user_id, presence: true, uniqueness: true
  validates :screen_name, presence: true, uniqueness: true
  validates :followed, inclusion: {in: [true, false]}

  after_validation :geocode_with_country_code, if: :postal_code_changed?

  scope :followed, proc { |bool| where(followed: bool) }
  scope :not_promted_for_postal_code, where(prompted_for_postal_code_at: nil)
  scope :promptable_for_postal_code, followed(true).not_promted_for_postal_code
  scope :with_postal_code, where('postal_code IS NOT NULL')
  scope :trackable, followed(true).with_postal_code

  geocoded_by :postal_code
  include HasCoordinates

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
    def prompt_for_postal_codes
      promptable_for_postal_code.each &:prompt_for_postal_code
    end

    # List DMs, process each for postal_code.
    # If postal_code cannot be processed, deny_postal_code.
    def process_DMs_for_postal_codes
      Twitter.direct_messages.each do |dm|
        postal_code = dm.extract_postal_code
        dm.destroy
        twitter_account = dm.twitter_account
        if postal_code
          twitter_account.process_postal_code(postal_code)
        else
          twitter_account.deny_postal_code
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

  # DM with instructions asking for postal_code,
  # mark as prompted.
  def prompt_for_postal_code
    dm! PromptForPostalCodeTweet.new
    update_attributes! prompted_for_postal_code_at: Time.now
  end

  # Using postal_code, find theaters.
  # If theaters found, send DM confirmation, else send DM denial.
  def find_theaters_and_confirm_or_deny_location
    begin
      TicketSources.for_country(self.country_code).find_theaters_near(postal_code)
      theaters = Theater.near(coordinates, 15)
      if theaters.any?
        confirm_location_with theaters
      else
        deny_theater_list
      end
    rescue
      if Campout.env.production?
        Mailer.exception($!)
      else
        raise
      end
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
  def confirm_location_with(theaters)
    dm! ConfirmTheatersTrackedTweet.new(theaters)
  end

  # Send DM denying any theaters near postal_code.
  def deny_theater_list
    dm! DenyTheatersTrackedTweet.new(postal_code)
  end

  def deny_postal_code
    dm! InvalidatePostalCodeTweet.new
  end

  def send_unsupported_country_message
    dm! UnsupportedCountryTweet.new(self.country_code)
  end

  # Set postal_code. if different than before, find theaters and confirm/deny location.
  # Wrap argument in PostalCode object and convert to string to ensure whitespaces removed.
  # Make sure to only find/assign theaters if postal_code is different so we don't sound like a broken record.
  def process_postal_code(postal_code)
    self.postal_code = PostalCode.new(postal_code.to_s).to_s
    if postal_code_changed?
      save!
      if in_supported_country?
        find_theaters_and_confirm_or_deny_location
      else
        send_unsupported_country_message
      end
    end
  end

  def theaters_not_tracking_for_movie(movie)
    ticket_notifications.for(movie).includes(:theater).map(&:theater)
  end

  def geocode_with_country_code
    geocoder_result = Geocoder.search(self.postal_code).first
    self.latitude     = geocoder_result.latitude
    self.longitude    = geocoder_result.longitude
    self.country_code = geocoder_result.country_code
  end

  def in_supported_country?
    TicketSources.support_country_code?(self.country_code)
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
