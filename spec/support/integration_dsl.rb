# Integration specs can use this DSL.

class IntegrationSpec < MiniTest::Spec
  class << self

    alias_method :scenario, :describe

  end
end

MiniTest::Spec.register_spec_type /workflow/i, IntegrationSpec
