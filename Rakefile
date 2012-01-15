require './init'

desc 'Check that parsing is working against all sources'
task :diagnostics do
  print 'movietickets.com...'
  begin
    MovieTickets.diagnostics
    puts 'OK'
  rescue
    Pony.mail(to: 'jared@redningja.com', subject: 'Campout diagnostics failure', body: $!.backtrace.join("\n"))
    puts 'failed. email sent'
  end
end

desc 'Email movies showing on given date at each theater'
task :list, [:date] do |t, args|
  date = Chronic.parse(args.date).to_date
  theaters = MovieTickets::Theater.all.each_with_object({}) do |theater, hash|
    movies = MovieTickets.scour(theater: theater, date: date).uniq(&:title)
    hash[theater] = movies unless movies.empty?
  end
  unless theaters.empty?
    h = Markaby::Builder.new
    html = h.html do
      h1 date
      theaters.each do |theater, movies|
        h2 theater.name
        ul do
          movies.each do |movie|
            li movie.title
          end
        end
      end
    end
    Pony.mail(to: 'jared@redningja.com', html_body: html)
    puts 'email sent'
  end
end
