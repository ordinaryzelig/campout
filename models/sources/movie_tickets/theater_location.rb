# This model is only used to fetch location data for a theater given a house_id.
# Not to be confused with TheaterSource, which is stored in DB.

class MovieTickets::TheaterLocation

  include RailsStyleInitialization
  include HTTParty
  base_uri 'http://www.movietickets.com/house_detail.asp'
  include HasCoordinates

  attr_accessor :name
  attr_accessor :address
  attr_accessor :latitude
  attr_accessor :longitude

  class << self

    def scour(house_id)
      html = get '', query: {house_id: house_id}
      loc = parse html
      loc.geocode
      loc
    end

    private

    def parse(html)
      doc = Nokogiri.HTML(html)
      new(
        name:    parse_name(doc),
        address: parse_address(doc),
      )
    end

    def parse_name(doc)
      doc.at_css('h1').content.strip
    end

    def parse_address(doc)
      street, city_state_zip, phone_number = doc.at_css('.ft2').inner_html.strip.split('<br>')
      [street, city_state_zip].join(', ')
    end

  end

  def attributes
    {
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
    }
  end

  def geocode
    latitude, longitude = Geocoder.coordinates(address)
    self.latitude = latitude
    self.longitude = longitude
  end

  def find_or_create_theater!
    existing_theater = ::Theater.find_by_coordinates(coordinates)
    if existing_theater
      return existing_theater
    else
      ::Theater.create! attributes
    end
  end

end
