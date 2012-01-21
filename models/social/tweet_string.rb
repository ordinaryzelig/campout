# String wrapper that limits length to 140 characters.

class TweetString

  CHARACTER_LIMIT = 140

  def initialize(string)
    @string = string.to_s
    self
  end

  def valid?
    num_chars_left >= 0
  end

  # If not valid?, raise exception.
  def validate!
    valid? || raise(LimitExceeded.new(@string))
  end

  def +(string)
    self.class.new(@string + string)
  end

  def to_s
    @string
  end

  # Number of characters left before exceeding limit.
  # If limit already exceeded, return 0.
  def num_chars_left
    CHARACTER_LIMIT - length
  end

  # Delegate missing methods to @string.
  def method_missing(*args, &block)
    @string.send(*args, &block)
  end

  class LimitExceeded < StandardError
    def initialize(string)
      message = "#{CHARACTER_LIMIT} character limit exceeded: #{string.length} - '#{string}'"
      super message
    end
  end

end
