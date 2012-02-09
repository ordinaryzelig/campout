FactoryGirl.define do

  factory :fandango_theater, class: Fandango::Theater do

    factory :fandango_amc do
      association :theater, factory: :amc
      external_id 5902
    end

    factory :fandango_warren do
      association :theater, factory: :warren
      external_id 10834
    end

  end

end
