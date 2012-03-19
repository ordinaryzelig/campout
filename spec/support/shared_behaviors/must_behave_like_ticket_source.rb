module MustBehaveLikeTicketSource

  def it_must_behave_like_ticket_source

    let(:ticket_source) { self.class.desc }

    it '.find_theaters_near is defined' do
      ticket_source.must_respond_to(:find_theaters_near)
    end

    it '.diagnostics is defined' do
      ticket_source.must_respond_to(:diagnostics)
    end

    it 'serves countries' do
      ticket_source.country_codes.wont_be_empty
    end

  end

end

MiniTest::Spec.extend MustBehaveLikeTicketSource
