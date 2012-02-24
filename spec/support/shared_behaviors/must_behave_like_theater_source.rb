module MustBehaveLikeTheaterSource

  def it_must_behave_like_theater_source

    it '#find_or_create! is defined' do
      self.class.desc.must_define_instance_method(:find_or_create!)
    end

  end

end

MiniTest::Spec.extend MustBehaveLikeTheaterSource
