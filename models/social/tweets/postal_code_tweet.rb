# Response from twitter account telling us their postal code.
# Use Geocoder to determine postal code.
class PostalCodeTweet < TweetString

  def postal_code
    return @postal_code if @postal_code
    search_result = Geocoder.search(self.to_s).first
    @postal_code = search_result.postal_code if search_result
  end

  def valid?
    !!postal_code
  end

end
