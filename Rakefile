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

desc 'Check for movie on specific day in zipcode'
task :check, [:pattern, :date, :zipcode] do |t, args|
  pattern = args.pattern
  date = Chronic.parse(args.date).to_date
  zipcode = args.zipcode
  movie = MovieTickets::Movie.search(pattern)
  theaters = movie.on_sale_at_theaters(date, zipcode)
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

desc 'Run cron.rb'
task :cron do
  load Campout.root_dir + 'cron.rb'
end

# ====================================
# Testing.

require 'rake/testtask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'spec'
  t.pattern = 'spec/**/*.spec.rb'
end
