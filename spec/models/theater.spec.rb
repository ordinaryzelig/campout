require 'spec_helper'

describe Theater do

  it 'does not use Geocoder if coordinates already exist' do
    Geocoder.expects(:coordinates).never
    theater = FactoryGirl.build(:amc, latitude: 0, longitude: 0)
    theater.valid?
  end

end
