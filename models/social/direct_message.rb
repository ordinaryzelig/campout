class Twitter::DirectMessage

  def destroy
    Twitter.direct_message_destroy id
  end

  # Attempt to extract zipcode and process.
  # If zipcode successfully extracted, assign to twitter account.
  # If zipcode cannot be processed, deny_zipcode.
  # Either way, delete DM.
  # If zipcode extracted and assigned, find and assigne theaters.
  def process_zipcode
    begin
      if zipcode = extract_zipcode
        twitter_account.update_attributes! zipcode: zipcode
        twitter_account.find_and_assign_theaters
      else
        twitter_account.deny_zipcode
      end
    ensure
      destroy
    end
  end

  # Find TwitterAccount from sender.
  def twitter_account
    @twitter_account ||= TwitterAccount.find_by_user_id(sender.id)
  end

  private

  # Extract zipcode from text.
  def extract_zipcode
    Zipcode.extract_from_string(text)
  end

end
