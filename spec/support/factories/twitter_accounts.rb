FactoryGirl.define do

  factory :twitter_account do
  end

  factory :redningja, class: 'TwitterAccount' do
    screen_name 'redningja'
    user_id     29482029
    location    'oklahoma city'
  end

end
