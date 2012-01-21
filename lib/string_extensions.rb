class String

  def truncate(max_length)
    if length > max_length
      num_periods = 2
      self[0, max_length - num_periods] + ('.' * num_periods)
    else
      self
    end
  end

end
