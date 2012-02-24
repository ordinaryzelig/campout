module MiniTest::Assertions

  # Given a class, check that method_name (symbol) is an instance method.
  def assert_instance_method_defined(klass, method_name, message = nil)
    message ||= "Expected #{klass.name} to define #{method_name}"
    assert_includes klass.instance_methods, method_name, message
  end

end

Class.infect_an_assertion :assert_instance_method_defined, :must_define_instance_method, :reverse
