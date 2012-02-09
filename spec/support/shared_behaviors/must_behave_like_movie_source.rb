class MiniTest::Spec

  class << self

    def it_must_behave_like_movie_source

      it 'must define #find_theaters_selling_at' do
        self.class.desc.public_instance_methods.must_include(:find_theaters_selling_at)
      end

    end

  end

end
