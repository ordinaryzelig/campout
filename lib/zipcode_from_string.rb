module Zipcode

  class << self

    # Just find 5 consecutive digits and return as integer.
    def extract_from_string(string)
      match_data = string.match(/(?<zipcode>\d{5})/)
      match_data and match_data[:zipcode].to_i
    end
  end

end
