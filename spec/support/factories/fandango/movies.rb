FactoryGirl.define do

  factory :fandango_movie_source, class: Fandango::Movie do

    factory :fandango_iron_lady do
      association :movie, factory: :iron_lady
      external_id 116928
    end

    factory :fandango_ghost_rider do
      association :movie, factory: :ghost_rider
      external_id 123162
    end

  end

end
