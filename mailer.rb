module Mailer

  class << self

    def exception(ex)
      Pony.mail(
        subject: "Campout failure: #{ex.message}",
        body: exception_body(ex),
      )
    end

    def rake_exception(ex)
      Pony.mail(
        subject: "Campout failure: rake #{Rake.application.top_level_tasks.join(' ')}",
        html_body: exception_body(ex),
      )
    end

    def on_sale(movie, theaters)
      Pony.mail(subject: "#{movie.title} is on sale!!!", body: theaters.map(&:name).join("\n"))
    end

    def cron_progress(body)
      Pony.mail(subject: "New progress", body: body)
    end

    def stats(body)
      Pony.mail(subject: 'Stats', body: body)
    end

    private

    def exception_body(ex)
      ([ex.class, ex.message] + ex.backtrace).join("<br />")
    end

  end

end
