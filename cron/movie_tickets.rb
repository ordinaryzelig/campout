new_accounts = TwitterAccount.create_from_followers
puts "#{new_accounts.size} new accounts. #{TwitterAccount.count} total."

if new_accounts.any?
  # Have each new account track The Dark Knight.
  dark_knight_imax = MovieTicketsMovie.find_by_title!('The Dark Knight Rises: The IMAX Experience')
  dark_knight      = MovieTicketsMovie.find_by_title!('The Dark Knight Rises')
  new_accounts.each do |account|
    account.movie_tickets_movies << dark_knight_imax
    account.movie_tickets_movies << dark_knight
  end
end
