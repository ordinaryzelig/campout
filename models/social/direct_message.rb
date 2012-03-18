class Twitter::DirectMessage

  def destroy
    Twitter.direct_message_destroy id
  end

  # Find TwitterAccount from sender.
  def twitter_account
    @twitter_account ||= TwitterAccount.find_by_user_id(sender.id)
  end

  # Assuming DM text is postal code, return validated postal code.
  # If not valid, return nil.
  def extract_postal_code
    postal_code_tweet = PostalCodeTweet.new(self.text)
    postal_code_tweet.valid? ? postal_code_tweet.to_s : nil
  end

end
