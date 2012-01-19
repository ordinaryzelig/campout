class Twitter::DirectMessage

  # Extract zipcode from text, assign to twitter account.
  def extract_and_assign_zipcode!
    if zipcode = extract_zipcode
      twitter_account.update_attributes! zipcode: zipcode
    end
  end

  # Extract zipcode from text.
  def extract_zipcode
    match_data = text.match(/(?<zipcode>\d{5})/)
    match_data and match_data[:zipcode].to_i
  end

  # Find TwitterAccount from sender.
  def twitter_account
    TwitterAccount.find_by_user_id(sender.id)
  end

  def destroy
    Twitter.direct_message_destroy id
  end

end
