FactoryGirl.define do

  factory :ticket_notification do
    association :twitter_account, factory: :redningja
    association :theater, factory: :amc
    association :movie, factory: :iron_lady
  end

end
