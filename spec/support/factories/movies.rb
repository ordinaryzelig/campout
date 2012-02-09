FactoryGirl.define do

  factory :movie do

    factory :iron_lady do
      title 'The Iron Lady'
      #movie_id 116928
      released_on Date.civil(2012, 1, 13)
    end

    factory :ghost_rider do
      title 'Ghost Rider 3D: Spirit of Vengeance'
      #movie_id 123162
      released_on Date.civil(2012, 2, 16)
    end

  end

end
