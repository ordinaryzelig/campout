new_followings    = TwitterAccount.follow_all_not_followed
prompted_accounts = TwitterAccount.prompt_for_zipcodes
processed_dms     = TwitterAccount.process_DMs_for_zipcodes

puts "#{new_followings.size} new followings."
puts "#{prompted_accounts.size} prompts for zipcodes"
puts "#{processed_dms.size} DMs processed for zipcodes"
