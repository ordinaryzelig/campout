# This used mainly for test rake tasks.

# Create some movies.
[
  {title: 'The Dark Knight Rises: The IMAX Experience', movie_id: 119747},
  {title: 'Ghost Rider 3D: Spirit of Vengeance',           movie_id: 123162},
  {title: 'The Iron Lady',                              movie_id: 116928},
].each do |atts|
  MovieTicketsMovie.create!(atts)
end

# Create AMC theater.
MovieTicketsTheater.create!({name: 'AMC Quail Springs Mall 24', house_id: 5902})
