module StubbingMacros

  def fixture_file(file_name)
    File.open("spec/support/fixtures/#{file_name}")
  end

  # Stub Feedzirra response with stored fixture file content.
  # This is a workaround because VCR doesn't support Feedzirra yet.
  # File contents cannot be obtained from Safari because it translates
  # it into HTML. Use Firefox to get original raw source.
  def stub_fandango_feed(file_name)
    Curl::Easy.expects(:new).never
    file_content = fixture_file(file_name).read
    feed = Feedzirra::Parser::RSS.parse(file_content)
    Feedzirra::Feed.expects(:fetch_and_parse).returns(feed)
  end

  # Stub Geocoder so that it returns coordinates based on an integer counter.
  # Distance between [0,0] and [1,1] is 97+ miles.
  def stub_geocoder_with_counter
    Geocoder.stubs(:coordinates).returns(*100.times.map { |i| [i, i] })
  end

  # Stub Geocoder gem to return 0, 0 as coordinates and 'US' as country_code.
  def disable_geocoding
    stub_geocoder 0.0, 0.0, 'US'
  end

  def stub_geocoder(latitude, longitude, country_code)
    require 'geocoder/results/base'
    stubbed_result = Geocoder::Result::Base.new({})
    stubbed_result.stubs(:coordinates).returns([latitude, longitude])
    stubbed_result.stubs(:country_code).returns(country_code)
    Geocoder.stubs(:search).returns([stubbed_result])
  end

end

MiniTest::Spec.send :include, StubbingMacros
