class MovieTickets::TheaterSource < TheaterSource

  class << self

    # Given zipcode, search site, parse, return theater listings.
    def scour(zipcode)
      agent = Mechanize.new
      # Go to home page, submit search with zipcode.
      home_page = agent.get 'http://www.movietickets.com'
      form = home_page.forms_with(action: 'http://www.movietickets.com/_search.asp').first
      form.Szip = zipcode
      page = form.submit
      # Parse result.
      parse page.body
    end

    private

    # Parse and return listing objects.
    def parse(html)
      doc = Nokogiri.HTML(html)
      ['#rw1', '#rw2'].map do |ul_id|
        doc.css("#{ul_id} li").map { |li| parse_li(li) }
      end.flatten
    end

    def parse_li(li)
      name = li.css('a').text.sub(/ - .*$/, '') # Strip city at end.
      external_id = li.css('a').first['href'].match(/house_id=(?<id>\d+)/)[:id]
      new(
        external_id: external_id,
        theater: Theater.new(name: name),
      )
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
