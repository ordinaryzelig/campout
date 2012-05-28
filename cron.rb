new_accounts      = TwitterAccount.create_from_followers
unfollowed_ids    = TwitterAccount.unfollow_non_followers
new_followings    = TwitterAccount.follow_all_not_followed
prompted_accounts = TwitterAccount.prompt_for_postal_codes
processed_dms     = TwitterAccount.process_DMs_for_postal_codes

puts "#{new_accounts.size} new accounts. #{TwitterAccount.count} total."
puts "#{unfollowed_ids.size} unfollowed accounts. #{TwitterAccount.followed(true).count} followed."
puts "#{new_followings.size} new followings."
puts "#{prompted_accounts.size} prompts for postal codes"
puts "#{processed_dms.size} DMs processed for postal codes"

if new_accounts.any?
  # Have each new account track The Dark Knight.
  dark_knight_imax = Movie.find_by_title!('The Dark Knight Rises: The IMAX Experience')
  dark_knight      = Movie.find_by_title!('The Dark Knight Rises')
  new_accounts.each do |account|
    account.movies.push *[dark_knight_imax, dark_knight]
  end
end
