require './init'

desc 'Check that parsing is working against all sources'
task :diagnostics do
  print 'movietickets.com...'
  begin
    MovieTickets::Theater.diagnostics
    puts 'OK'
  rescue
    if Campout.env.production?
      Pony.mail(to: 'ningja@me.com', subject: 'Campout diagnostics failure', body: $!.backtrace.join("\n"))
      puts 'failed. email sent'
    else
      puts 'error'
      raise
    end
  end
end

desc 'Check for movie on specific day'
task :check, [:pattern, :date] do |t, args|
  pattern = args.pattern
  date = Chronic.parse(args.date).to_date
  theaters = MovieTickets::Theater.all.each_with_object([]) do |theater, array|
    movies = MovieTickets::Theater.scour(theater: theater, date: date).uniq(&:title)
    array << theater if movies.any? { |movie| movie.title =~ Regexp.new(pattern, 'i') }
  end
  if theaters.empty?
    puts 'no go'
  else
    if Campout.env.production?
      Pony.mail(to: 'ningja@me.com', subject: "#{pattern} is on sale!!!", body: theaters.map(&:name).join("\n"))
      puts 'email sent'
    else
      puts theaters.map(&:name)
    end
  end
end

# ====================================
# Testing.

require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'spec'
  t.pattern = 'spec/**/*.spec.rb'
end
