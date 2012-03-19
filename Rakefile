# ====================================
# DB.

namespace :db do

  desc 'Seed data'
  task :seed => :connect do
    load './db/seed.rb'
  end

  desc 'Migrate DB.'
  task :migrate => :connect do
    ActiveRecord::Migrator.migrate('db/migrations')
  end

  task :connect do
    require './db/connect'
  end

end

# ====================================
# Campout.

desc 'Check that parsing is working against all sources'
task :diagnostics => 'db:connect' do
  mail_on_error do
    TicketSources.all.each do |source|
      print "#{source.name}..."
      source.diagnostics
      puts 'OK'
    end
  end
end

desc 'Run cron.rb'
task :cron => 'db:connect' do
  mail_on_error do
    load Campout.root_dir + 'cron.rb'
  end
end

desc 'check for ticket sales on all unreleased movies and live trackers'
task 'scour' => 'db:connect' do
  mail_on_error do
    accounts_notified = Movie.check_for_newly_released_tickets
    if accounts_notified.any?
      message = "#{accounts_notified.size} notified\n"
      message += accounts_notified.map(&:postal_code).join("\n")
      Mailer.cron_progress(message)
      puts message
    end
  end
end

desc 'Do some queries, get some numbers'
task :stats => 'db:connect' do
  body = []
  body << "#{TwitterAccount.count} twitter accounts."
  body << "#{Theater.count} theaters."
  body = body.join("\n")
  Mailer.stats(body)
  puts body
end

desc 'Geocode objects that need it'
task :geocode => 'db:connect' do
  mail_on_error do
    Geocoder.loop_on_query_limit_exception do
      ActiveRecord::Base.descendants.each do |model|
        if model.geocoder_options
          print "#{model}: "
          to_geocode = model.not_geocoded
          puts to_geocode.count
          to_geocode.each(&:save!)
        end
      end
    end
  end
end

desc 'For each TwitterAccount, find or create theaters'
task :find_or_create_theaters => 'db:connect' do
  mail_on_error do
    count = TwitterAccount.count
    TwitterAccount.all.each_with_index do |account, idx|
      next unless account.postal_code
      puts "#{account.postal_code} (id: #{account.id}, #{idx + 1} of #{count})"
      Geocoder.loop_on_query_limit_exception do
        TicketSources.find_theaters_near(account.postal_code)
      end
      puts
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

# ====================================
# Error handler.

def mail_on_error
  yield
rescue
  puts 'error'
  if Campout.env.production?
    Mailer.rake_exception($!)
    puts 'email sent'
  end
  # Output exception.
  puts $!.class
  puts $!.message
  puts $!.backtrace
end
