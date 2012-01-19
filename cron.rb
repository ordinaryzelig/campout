fork do
  TwitterAccount.create_from_followers
  TwitterAccount.follow_all_not_followed
  TwitterAccount.prompt_for_zipcodes
end

fork do
  TwitterAccount.process_DMs_for_zipcodes
end

Process.wait

#Check for movies
  #1 zipcode at a time...
    #check if all matching theaters already searched
    #if not, search for zipcode and update theater last searched date

#Notify of ticket sales
  #for each account not yet notified and with theaters selling tickets...
    #DM list of theaters selling tickets
    #mark as notified
