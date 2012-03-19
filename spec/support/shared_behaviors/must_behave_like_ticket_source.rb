module MustBehaveLikeTicketSource

  def it_must_behave_like_ticket_source

    let(:ticket_source) { self.class.desc }

    it '.find_theaters_near is defined' do
      ticket_source.must_respond_to(:find_theaters_near)
    end

    it '.diagnostics is defined' do
      ticket_source.must_respond_to(:diagnostics)
    end

    it 'supports countries' do
      ticket_source.country_codes.must_be_kind_of Array
      ticket_source.country_codes.each do |country_code|
        ticket_source.supports_country_code?(country_code).must_equal true
      end
    end

  end

end

MiniTest::Spec.extend MustBehaveLikeTicketSource
