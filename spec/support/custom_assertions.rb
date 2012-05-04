module MiniTest::Assertions

  # Given a class, check that method_name (symbol) is an instance method.
  def assert_instance_method_defined(klass, method_name, message = nil)
    message ||= "Expected #{klass.name} to define #{method_name}"
    assert_includes klass.instance_methods, method_name, message
  end
  Class.infect_an_assertion :assert_instance_method_defined, :must_define_instance_method, :reverse

  def assert_valid_postal_code_tweet(string)
    assert PostalCodeTweet.new(string).valid?, "Expected '#{string}' to be valid PostalCodeTweet"
  end
  String.infect_an_assertion :assert_valid_postal_code_tweet, :must_be_valid_postal_code_tweet, :unary

  def refute_valid_postal_code_tweet(string)
    assert !PostalCodeTweet.new(string).valid?, "Expected '#{string}' to be invalid PostalCodeTweet"
  end
  String.infect_an_assertion :refute_valid_postal_code_tweet, :wont_be_valid_postal_code_tweet, :unary

end
