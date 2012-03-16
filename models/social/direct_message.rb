class Twitter::DirectMessage

  def destroy
    Twitter.direct_message_destroy id
  end

  # Find TwitterAccount from sender.
  def twitter_account
    @twitter_account ||= TwitterAccount.find_by_user_id(sender.id)
  end

  def extract_postal_code
    PostalCode.extract_from_string(self.text)
  end

end
