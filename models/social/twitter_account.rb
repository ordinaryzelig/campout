class TwitterAccount < ActiveRecord::Base

  has_many :theater_assignments
  has_many :movie_tickets_theaters, through: :theater_assignments do
    def closest
      first
    end
  end

  validates :user_id, presence: true, uniqueness: true
  validates :screen_name, presence: true, uniqueness: true
  validates :followed, inclusion: {in: [true, false]}
  validates :zipcode, numericality: {allow_nil: true, greater_than_or_equal_to: 10000, less_than_or_equal_to: 99999}

  scope :followed, proc { |bool| where(followed: bool) }
  scope :not_prompted_for_zipcode, where(prompted_for_zipcode_at: nil)
  scope :promptable_for_zipcode, followed(true).not_prompted_for_zipcode

  class << self

    # Create new twitter accounts from followers.
    # list followers that are not yet followed.
    # create new twitter account in DB.
    def create_from_followers
      new_follower_ids.each do |follower_id|
        twitter_user = Twitter.user(follower_id)
        create_from_twitter_user!(twitter_user)
      end
    end

    # Follow back twitter accounts not yet followed.
    # Mark as followed.
    def follow_all_not_followed
      followed(false).each do |twitter_account|
        Twitter.follow(twitter_account.user_id)
        twitter_account.update_attributes! followed: true
      end
    end

    # Prompt each twitter account that we are following that has not yet been prompted.
    def prompt_for_zipcodes
      promptable_for_zipcode.each &:prompt_for_zipcode
    end

    # List DMs, process each for zipcode.
    def process_DMs_for_zipcodes
      Twitter.direct_messages.each &:process_zipcode
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
    dm! 'What is your zipcode?'
    update_attributes! prompted_for_zipcode_at: Time.now
  end

  # Send DM with closest theater (should be first) and instructions on how to change.
  def confirm_location_with_theater_list
    message_without_theater = "I'm tracking some theaters for you including %s. If this is wrong, send me a Direct Message with the correct zipcode."
    chars_left = TweetString::CHARACTER_LIMIT - (message_without_theater.length - 2) # Don't count the '%s'.
    closest_theater_name = movie_tickets_theaters.closest.name.truncate(chars_left)
    message = message_without_theater.sub('%s', closest_theater_name)
    dm! message
    true
  end

  # Send DM denying any theaters near zipcode.
  def deny_theater_list
    dm! "Sorry. I couldn't find any theaters near #{zipcode}. Send me a Direct Message with another zipcode and I'll try again."
  end

  def deny_zipcode
    dm! "Sorry. I couldn't understand your zipcode. Please send me a Direct Message with a valid zipcode. e.g. 12345"
  end

  # Using zipcode, find or create theaters,
  # assign them to account's theaters.
  # Confirm location.
  # Destroy old assignments no matter what.
  def find_and_assign_theaters
    # Out with the old, in with the new.
    theater_assignments.destroy
    theaters = MovieTicketsTheaterList.scour(self.zipcode)
    if theaters.any?
      update_attributes!(
        movie_tickets_theaters: theaters,
      )
      confirm_location_with_theater_list
    else
      deny_theater_list
    end
  end

  private

  # Send a DM with message. Return true if successful.
  # Wrap message in TweetString.
  def dm!(message)
    Twitter.direct_message_create(self.user_id, TweetString.new(message))
    true
  end

end
