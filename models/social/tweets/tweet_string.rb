# String wrapper that limits length to 140 characters.
class TweetString

  attr_reader :character_limit

  def initialize(string, options = {})
    @string = string.to_s
    @character_limit = options[:character_limit] || 140
  end

  def valid?
    within_character_limit?
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

  # Use to_s to compare to other objects.
  def ==(obj)
    to_s == obj.to_s
  end

  # Number of characters left before exceeding limit.
  # If limit already exceeded, return 0.
  def num_chars_left
    @character_limit - length
  end

  def within_character_limit?
    num_chars_left >= 0
  end

  # Delegate missing methods to @string.
  def method_missing(*args, &block)
    @string.send(*args, &block)
  end

  class LimitExceeded < StandardError
    def initialize(string)
      message = "#{@character_limit} character limit exceeded: #{string.length} - '#{string}'"
      super message
    end
  end

end
