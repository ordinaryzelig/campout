new_accounts = TwitterAccount.create_from_followers

# Have each new account track The Dark Knight.
dark_knight = MovieTicketsMovie.find_by_title!('The Dark Knight Rises: The IMAX Experience')
new_accounts.each do |account|
  account.movie_tickets_movies << dark_knight
end

new_followings    = TwitterAccount.follow_all_not_followed
prompted_accounts = TwitterAccount.prompt_for_zipcodes
processed_dms     = TwitterAccount.process_DMs_for_zipcodes

# Email progress if any.
if (new_accounts + new_followings + prompted_accounts + processed_dms).any?
  body = [
    "#{new_accounts.size} new accounts. #{TwitterAccount.count} total.",
    "#{new_followings.size} new followings.",
    "#{prompted_accounts.size} prompts for zipcodes",
    "#{processed_dms.size} DMs processed for zipcodes",
  ].join("\n")
  Mailer.cron_progress(body)
  # Output to command line too.
  puts body
end

=begin

Check for movies on sale at theaters
  for each movie tracker
    for each twitter account
      scour for zipcode on [release date, Date.today].max
      mark each theater

Notify of ticket sales
  for each account not yet notified and with theaters selling tickets...
    DM list of theaters selling tickets
    mark as notified
=end
