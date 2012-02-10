class MiniTest::Spec

  class << self

    def it_must_behave_like_ticket_source

      it '.find_theaters_near is defined' do
        self.class.desc.must_respond_to(:find_theaters_near)
      end

    end

  end

end
