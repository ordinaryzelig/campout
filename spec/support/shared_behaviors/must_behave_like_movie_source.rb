module MustBehaveLikeMovieSource

  def it_must_behave_like_movie_source

    it 'must define #find_theaters_selling_at' do
      self.class.desc.must_define_instance_method(:find_theaters_selling_at)
    end

  end

end

MiniTest::Spec.extend MustBehaveLikeMovieSource
