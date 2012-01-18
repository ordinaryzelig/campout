class TwitterAccount < ActiveRecord::Base

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
        twitter_account.update_attributes followed: true
      end
    end

    # Prompt each twitter account that we are following that has not yet been prompted.
    def prompt_for_zipcodes
      promptable_for_zipcode.each &:prompt_for_zipcode
    end

    # List DMs, extract zipcode, assign to twitter account, delete DM.
    def process_DMs_for_zipcodes
      Twitter.direct_messages.each do |dm|
        dm.extract_and_assign_zipcode!
        dm.destroy
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
    message = TweetString.new('What is your zipcode?')
    Twitter.direct_message_create(user_id, message.to_s)
    update_attributes prompted_for_zipcode_at: Time.now
  end

end
