class PostalCode

  def initialize(obj)
    @string = obj.to_s
  end

  # Non-white space should contain either all numbers (US) or
  # combination of letters and numbers (Canada, UK).
  # These are not official regular expressions.
  def valid?
    !!(@string =~ /\d{5}|[a-z]+.*\d+/i)
  end

  def to_s
    @string
  end

end
