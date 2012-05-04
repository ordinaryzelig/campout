class Twitter::DirectMessage

  def destroy
    Twitter.direct_message_destroy id
  end

  # Find TwitterAccount from sender.
  def twitter_account
    @twitter_account ||= TwitterAccount.find_by_user_id(sender.id)
  end

  # Assuming DM text is location, return geocoded postal code.
  def extract_postal_code
    PostalCodeTweet.new(self.text).postal_code
  end

end
