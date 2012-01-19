class String

  def truncate(max_length)
    if length > max_length
      self[0, max_length - 3] + '...'
    else
      self
    end
  end

end
