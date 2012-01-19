FactoryGirl.define do

  factory :movie_tickets_theater do

    factory :movie_tickets_amc do
      name 'AMC Quail Springs Mall 24'
      house_id 5902
    end

    factory :movie_tickets_warren do
      name 'Moore Warren Theatre'
      house_id 10834
    end

  end

end
