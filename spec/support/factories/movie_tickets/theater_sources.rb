FactoryGirl.define do

  factory :movie_tickets_theater_source, class: MovieTickets::TheaterSource do

    factory :movie_tickets_amc do
      association :theater, factory: :amc
      external_id 116928
    end

  end

end
