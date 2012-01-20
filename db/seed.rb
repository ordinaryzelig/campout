# This used mainly for test rake tasks.

# Create some movies.
[
  {title: 'The Dark Knight Rises: The IMAX Experience', movie_id: 119747, released_on: Date.civil(2012, 7, 19)},
  {title: 'Ghost Rider 3D: Spirit of Vengeance',        movie_id: 123162, released_on: Date.civil(2012, 2, 16)},
  {title: 'The Iron Lady',                              movie_id: 116928, released_on: Date.civil(2012, 1, 13)},
].each do |atts|
  MovieTicketsMovie.create!(atts)
end

# Create AMC theater.
MovieTicketsTheater.create!({name: 'AMC Quail Springs Mall 24', house_id: 5902})
