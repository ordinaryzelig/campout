FactoryGirl.define do

  factory :movie_tickets_movie_source, class: MovieTickets::MovieSource do

    factory :movie_tickets_iron_lady do
      association :movie, factory: :iron_lady
      external_id 116928
    end

    factory :movie_tickets_ghost_rider do
      association :movie, factory: :ghost_rider
      external_id 123162
    end

  end

end
