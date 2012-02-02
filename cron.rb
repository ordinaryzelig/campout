new_accounts = TwitterAccount.create_from_followers

if new_accounts.any?
  # Have each new account track The Dark Knight.
  dark_knight_imax = MovieTicketsMovie.find_by_title!('The Dark Knight Rises: The IMAX Experience')
  dark_knight      = MovieTicketsMovie.find_by_title!('The Dark Knight Rises')
  new_accounts.each do |account|
    account.movie_tickets_movies << dark_knight_imax
    account.movie_tickets_movies << dark_knight
  end
end

new_followings    = TwitterAccount.follow_all_not_followed
prompted_accounts = TwitterAccount.prompt_for_zipcodes
processed_dms     = TwitterAccount.process_DMs_for_zipcodes

body = [
  "#{new_accounts.size} new accounts. #{TwitterAccount.count} total.",
  "#{new_followings.size} new followings.",
  "#{prompted_accounts.size} prompts for zipcodes",
  "#{processed_dms.size} DMs processed for zipcodes",
].join("\n")
puts body
