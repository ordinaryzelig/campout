FactoryGirl.define do

  factory :ticket_notification do
    association :twitter_account, factory: :redningja
    theater_source { Fandango::Theater.new(name: 'amc', external_id: 'asdf') }
    association :movie, factory: :iron_lady
  end

end
