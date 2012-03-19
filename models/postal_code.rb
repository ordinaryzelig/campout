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
    @string.gsub(' ', '')
  end

  class << self

    # Assume postal code is last token in address.
    def extract_from_address(address)
      match = address.match(/(?<postal_code>\S+)$/)
      new(match ? match[:postal_code] : nil)
    end

  end

end
