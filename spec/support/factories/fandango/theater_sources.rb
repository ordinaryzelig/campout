FactoryGirl.define do

  factory :fandango_theater_source, class: Fandango::TheaterSource do

    factory :fandango_amc do
      association :theater, factory: :amc
      external_id 'aaktw'
    end

  end

end
