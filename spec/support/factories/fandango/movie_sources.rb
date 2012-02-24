FactoryGirl.define do

  factory :fandango_movie_source, class: Fandango::MovieSource do

    factory :fandango_ghost_rider do
      association :movie, factory: :ghost_rider
      external_id 147109
    end

  end

end
