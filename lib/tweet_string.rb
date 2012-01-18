# String wrapper that limits length to 140 characters.

class TweetString

  # Undefine most methods so that we can delegate to @string.
  (public_instance_methods - [:object_id, :__send__]).each { |meth| undef_method meth }

  CHARACTER_LIMIT = 140

  def initialize(string)
    raise LimitExceeded.new(string) if string.length > CHARACTER_LIMIT
    @string = string
  end

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
