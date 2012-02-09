FactoryGirl.define do

  factory :movie_tickets_theater, class: MovieTickets::Theater do

    factory :movie_tickets_amc do
      association :theater, factory: :amc
      external_id 5902
    end

    factory :movie_tickets_warren do
      association :theater, factory: :warren
      external_id 10834
    end

  end

end
