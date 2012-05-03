class MovieTickets::TheaterSource < TheaterSource

  # Country codes mapped to MovieTickets.com languages.
  LANGUAGES = {
    'US' => 0,
    #'CA' => 1,  # French Canadian.
    'CA' => 2,   # Canada.
    'GB' => 3,   # UK, Great Britain.
    'IE' => 4,   # Ireland.
    'AR' => 5,   # Argentina.
    #'US' => 6,  # US Spanish.
    'MX' => 7,   # Mexico.
    #'IE' => 8,  # Northern Ireland.
    #'??' => 9,  # Caribbean.
    #'??' => 10, # NONE.
    'ES' => 11,  # Spain.
  }

  IRELAND_COUNTIES = {
    'meath'     => 1,
    'carlow'    => 2,
    'cavan'     => 3,
    'clare'     => 4,
    'cork'      => 5,
    'donegal'   => 6,
    'dublin'    => 7,
    'galway'    => 8,
    'kerry'     => 9,
    'kildare'   => 10,
    'kilkenny'  => 11,
    'laois'     => 12,
    'limerick'  => 14,
    'longford'  => 15,
    'louth'     => 16,
    'mayo'      => 17,
    'monaghan'  => 18,
    'offaly'    => 19,
    'roscommon' => 22,
    'sligo'     => 20,
    'tipperary' => 21,
    'waterford' => 23,
    'westmeath' => 24,
    'wexford'   => 25,
    'wicklow'   => 26,
  }

  class << self

    # Given postal_code and country_code, search site, parse, return theater sources.
    def scour(postal_code, country_code)
      case country_code
      when 'US', 'GB', 'CA'
        scour_by_form_submission(postal_code, country_code)
      when 'IE'
        scour_ireland(postal_code, country_code)
      else
        raise "Unknown country code: #{country_code}"
      end
    end

    # Go to home page specific to country code,
    # submit search with postal_code,
    # parse results
    def scour_by_form_submission(postal_code, country_code)
      agent = Mechanize.new
      home_page = agent.get(home_page_url(country_code))
      form = home_page.forms_with(action: 'http://www.movietickets.com/_search.asp').first
      form.Szip = postal_code
      page = form.submit
      parse page.body
    end

    # Go to home page for Ireland, go to URL for county.
    def scour_ireland(postal_code, country_code)
      agent = Mechanize.new
      home_page = agent.get(home_page_url(country_code))
      county = postal_code.strip.downcase
      url = "http://www.movietickets.com/house_list.asp?SearchZip=#{IRELAND_COUNTIES[county]}&SearchLang=4"
      html = agent.get(url).body
      parse html
    end

    # Search for theaters near 73142.
    # Make sure it includes AMC Quail.
    def diagnostics
      theater_sources = MovieTickets::TheaterSource.scour(73142, 'US')
      raise 'AMC not found' unless theater_sources.map(&:external_id).include?('5902')
    end

    private

    # Parse and return theater_source objects.
    def parse(html)
      doc = Nokogiri.HTML(html)
      doc.css("ul#tkdrow li").map { |li| parse_li(li) }
    end

    def parse_li(li)
      name = li.css('a').text.sub(/ - .*$/, '') # Strip city at end.
      external_id = li.css('a').first['href'].match(/house_id=(?<id>\d+)/)[:id]
      new(
        external_id: external_id,
        theater: Theater.new(name: name),
      )
    end

    def home_page_url(country_code)
      if country_code == 'US'
        "http://www.movietickets.com"
      else
        "http://www.movietickets.com?language=#{LANGUAGES[country_code]}"
      end
    end

  end

  # If theater source already exists, get it and return it.
  # If it doesn't, create it.
  # Create the theater from the location if necessary.
  def find_or_create!
    existing = self.class.find_by_external_id(external_id)
    return existing if existing
    theater = location.find_or_create_theater!
    self.class.create! theater: theater, external_id: external_id
  end

  # Locate theater using TheaterLocation model.
  def location
    @location ||= MovieTickets::TheaterLocation.scour(external_id)
  end

end
