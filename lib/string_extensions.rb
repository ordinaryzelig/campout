class String

  def truncate(max_length)
    if length > max_length
      num_periods = 2
      self[0, max_length - num_periods] + ('.' * num_periods)
    else
      self
    end
  end

  # Remove common names like theater, cinema. Remove trailing numbers.
  # If nothing left, just leave it alone.
  def to_theater_short_name
    short_name = gsub(/\b(cinema|theater|theatre)s?\b/i, ''). # remove theater, theatre
                 sub(/\d+$/, '').  # remove trailing digits
                 strip.            # remove extraneous white space
                 gsub(/ \s*/, ' ') # replace multiple whitespaces with single space
    short_name.blank? ? self : short_name
  end

end
