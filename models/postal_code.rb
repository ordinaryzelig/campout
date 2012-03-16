module PostalCode

  class << self

    # Just find 5 consecutive digits and return as integer.
    def extract_from_string(string)
      match_data = string.match(/(?<postal_code>\d{5})/)
      match_data and match_data[:postal_code]
    end
  end

end
