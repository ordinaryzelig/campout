module Mailer

  class << self

    def exception(ex)
      Pony.mail(
        subject: "Campout failure: #{ex.message}",
        body: ([ex.message] + ex.backtrace).join("\n")
      )
    end

    def on_sale(movie, theaters)
      Pony.mail(subject: "#{movie.title} is on sale!!!", body: theaters.map(&:name).join("\n"))
    end

  end

end