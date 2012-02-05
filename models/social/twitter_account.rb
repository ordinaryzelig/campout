class TwitterAccount < ActiveRecord::Base

  has_many :movie_tickets_theater_assignments, dependent: :destroy
  has_many :movie_tickets_theaters, through: :movie_tickets_theater_assignments do
    def closest
      first
    end
  end
  has_many :movie_tickets_movie_assignments, dependent: :destroy
  has_many :movie_tickets_movies, through: :movie_tickets_movie_assignments
  has_many :movie_tickets_trackers

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
    # If zipcode extracted and assigned (and different), find and assigne theaters.
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
          twitter_account.zipcode = zipcode
          if twitter_account.zipcode_changed?
            twitter_account.save!
            twitter_account.find_and_assign_theaters
            twitter_account.confirm_or_deny_theaters
          end
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
    dm! 'What is your zipcode? (I am a robot. Go to http://campout.heroku.com for more info.)'
    update_attributes! prompted_for_zipcode_at: Time.now
  end

  def deny_zipcode
    dm! "Sorry. I didn't understand your zipcode (I'm a robot). Please send me a Direct Message with a valid zipcode. e.g. 12345. (US only for now)"
  end

  # Using zipcode, find or create theaters,
  # assign them to account's theaters.
  # Destroy old assignments no matter what.
  def find_and_assign_theaters
    # Out with the old, in with the new.
    movie_tickets_theater_assignments.clear
    theaters = MovieTicketsTheaterList.scour(self.zipcode)
    # Don't create theaters if they already exist.
    theaters.map! &:find_or_create!
    if theaters.any?
      update_attributes!(
        movie_tickets_theaters: theaters,
      )
    end
    theaters
  end

  # Given trackers, DM with movie and trackers' theaters.
  # Close trackers.
  def notify_about_tickets!(trackers)
    raise 'no trackers to notify' if trackers.empty? # Don't look stupid.
    dm! TicketsOnSaleTweet.new(trackers)
    trackers.each &:close
  end

  def confirm_or_deny_theaters
    if movie_tickets_theaters.any?
      confirm_location_with_theater_list
    else
      deny_theater_list
    end
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

  # Send DM with closest theater (should be first) and instructions on how to change.
  def confirm_location_with_theater_list
    message_without_theater = TweetString.new("I'm tracking #{movie_tickets_theaters.size} theaters including %s. If this is wrong, send me a Direct Message with the correct zipcode.")
    chars_left = message_without_theater.num_chars_left - 2 # Don't count the '%s'.
    closest_theater_name = movie_tickets_theaters.closest.short_name.truncate(chars_left)
    message = message_without_theater.sub('%s', closest_theater_name)
    dm! message
    true
  end

  # Send DM denying any theaters near zipcode.
  def deny_theater_list
    dm! "Sorry. I couldn't find any theaters near #{zipcode}. Send me a Direct Message with another zipcode and I'll try again."
  end

end
