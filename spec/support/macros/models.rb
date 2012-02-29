module ModelMacros

  # Use VCR to get TwitterAccount.new_follower_ids.
  def new_follower_ids
    VCR.use_cassette('twitter/following') do
      TwitterAccount.send :new_follower_ids
    end
  end

  # Stub Geocoder gem to return 0, 0 as coordinates.
  def disable_geocoding
    Geocoder.stubs(:coordinates).returns([0, 0])
    # Stub geocode on models that call geocoded_by.
    ActiveRecord::Base.descendants.each do |model|
      if model._validation_callbacks.detect { |vc| vc.filter == :geocode }
        model.any_instance.stubs(:geocode).returns([0, 0])
      end
    end
  end

end

MiniTest::Spec.send :include, ModelMacros
