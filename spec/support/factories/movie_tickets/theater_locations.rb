FactoryGirl.define do

  factory :movie_tickets_theater_location, class: MovieTickets::TheaterLocation do

    factory :movie_tickets_amc_location do
      name 'amc'
      address '2501 West Memorial Road, Oklahoma City, OK, 73134'
      latitude 35.612151
      longitude -97.56118900000001
    end

  end

end
