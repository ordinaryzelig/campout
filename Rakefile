require './init'

desc 'Check that parsing is working against all sources'
task :diagnostics do
  print 'movietickets.com...'
  begin
    MovieTickets.diagnostics
    puts 'OK'
  rescue
    Pony.mail(to: 'ningja@me.com', subject: 'Campout diagnostics failure', body: $!.backtrace.join("\n"))
    puts 'failed. email sent'
  end
end

desc 'Check for movie on specific day'
task :check, [:pattern, :date] do |t, args|
  pattern = args.pattern
  date = Chronic.parse(args.date).to_date
  theaters = MovieTickets::Theater.all.each_with_object([]) do |theater, array|
    movies = MovieTickets.scour(theater: theater, date: date).uniq(&:title)
    array << theater if movies.any? { |movie| movie.title =~ Regexp.new(pattern, 'i') }
  end
  if theaters.empty?
    puts 'no go'
  else
    Pony.mail(to: 'ningja@me.com', subject: "#{pattern} is on sale!!!", body: theaters.map(&:name).join("\n"))
    puts 'email sent'
  end
end
