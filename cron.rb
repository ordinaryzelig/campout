# Do work.
new_accounts      = TwitterAccount.create_from_followers
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
  Pony.mail(to: 'ningja@me.com', subject: "New progress", body: body)
  puts body
end

#Check for movies
  #1 zipcode at a time...
    #check if all matching theaters already searched
    #if not, search for zipcode and update theater last searched date

#Notify of ticket sales
  #for each account not yet notified and with theaters selling tickets...
    #DM list of theaters selling tickets
    #mark as notified
