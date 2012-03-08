# encoding: utf-8
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
  attr_accessor :first_movie_id # For diagnostics.

  class << self

    def scour(house_id, diagnostics = false)
      html = get '', query: {house_id: house_id}
      loc = parse html, diagnostics
      loc.geocode
      loc
    end

    # Find address for AMC Quail.
    def diagnostics
      loc = scour 5902
      address = '2501 West Memorial, Oklahoma City, OK&#160;73134'
      raise "AMC address not parsing correctly: #{loc.address} expected to equal #{address}" unless loc.address == address
    end

    private

    def parse(html, diagnostics)
      doc = Nokogiri.HTML(html)
      loc = new(
        name:    parse_name(doc),
        address: parse_address(doc),
      )
      loc.first_movie_id = parse_first_movie_id(doc) if diagnostics
      loc
    end

    def parse_name(doc)
      doc.at_css('h1').content.strip
    end

    def parse_address(doc)
      *street, city_state_zip, phone_number = doc.at_css('.ft2').inner_html.strip.split('<br>')
      [street, city_state_zip].flatten.join(', ')
    end

    # For diagnostics purposes, just grab the first movie's id and return new MovieTickets::MovieSource.
    def parse_first_movie_id(doc)
      link = doc.at_css('#rw3 h4 a')
      link['href'].match(/movie_id=(?<movie_id>\d+)/)[:movie_id]
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
    latitude, longitude = Coordinates.from_address(address)
    self.latitude = latitude
    self.longitude = longitude
  end

  def find_or_create_theater!
    existing_theater = ::Theater.find_by_short_name_and_coordinates(short_name, coordinates)
    if existing_theater
      return existing_theater
    else
      ::Theater.create! attributes
    end
  end

  def short_name
    name.to_theater_short_name
  end

end
