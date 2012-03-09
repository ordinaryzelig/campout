module ModelMacros

  # Use VCR to get TwitterAccount.new_follower_ids.
  def new_follower_ids
    VCR.use_cassette('twitter/following') do
      TwitterAccount.send :new_follower_ids
    end
  end

end

MiniTest::Spec.send :include, ModelMacros
