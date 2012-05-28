module StubbingMacros

  def fixture_file(file_name)
    File.open("spec/support/fixtures/#{file_name}")
  end

  # Stub Fandango.movies_near with parsed results of file content.
  def stub_fandango_feed(file_name)
    file_content = fixture_file(file_name).read
    hash = Fandango.parse(file_content)
    Fandango.stubs(:movies_near).returns(hash)
  end

  def stub_geocoder(latitude, longitude, country_code, postal_code)
    search_result = mock_geocoder_search_result(latitude, longitude, country_code, postal_code)
    Geocoder.stubs(:search).returns([search_result])
  end

  def mock_geocoder_search_result(latitude, longitude, country_code, postal_code)
    require 'geocoder/results/base'
    mocked_result = MiniTest::Mock.new
    mocked_result.stubs(:latitude).returns(latitude)
    mocked_result.stubs(:longitude).returns(longitude)
    mocked_result.stubs(:coordinates).returns([latitude, longitude])
    mocked_result.stubs(:country_code).returns(country_code)
    mocked_result.stubs(:postal_code).returns(postal_code)
    mocked_result
  end

  # Stub Geocoder that returns no results.
  def stub_empty_geocoder
    Geocoder.stubs(:search).returns([])
  end

end

MiniTest::Spec.send :include, StubbingMacros
