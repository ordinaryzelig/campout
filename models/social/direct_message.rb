class Twitter::DirectMessage

  # Extract zipcode from text.
  def extract_zipcode
    Zipcode.extract_from_string(text)
  end

  # Find TwitterAccount from sender.
  def twitter_account
    TwitterAccount.find_by_user_id(sender.id)
  end

  def destroy
    Twitter.direct_message_destroy id
  end

end
