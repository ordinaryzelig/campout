# MovieTickets.com.

class MovieTickets < Movie

  class << self

    def parse(html)
      doc = Nokogiri.HTML(html)
      doc.css('#rw3 li').map do |li|
        movie = new(
          title: li.css('h4 a').text,
        )
      end
    end

  end

end
