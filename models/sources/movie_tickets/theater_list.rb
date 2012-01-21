class MovieTicketsTheaterList

  class << self

    # Given zipcode, search site, parse, return theaters.
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

    # Parse and return new theaters (not saved to DB).
    def parse(html)
      doc = Nokogiri.HTML(html)
      ['#rw1', '#rw2'].map do |ul_id|
        doc.css("#{ul_id} li").map { |li| parse_li(li) }
      end.flatten
    end

    def parse_li(li)
      MovieTicketsTheater.new(
        name: li.css('a').text.sub(/ - .*$/, ''), # Strip city at end.
        house_id: li.css('a').first['href'].match(/house_id=(?<id>\d+)/)[:id],
      )
    end

  end

end
