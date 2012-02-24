# This used mainly for test rake tasks.

# Create some movies.
[
  {title: 'The Dark Knight Rises: The IMAX Experience', movie_id: 119747, released_on: Date.civil(2012, 7, 19)},
  {title: 'The Dark Knight Rises',                      movie_id: 117274, released_on: Date.civil(2012, 7, 19)},
  {title: 'Ghost Rider 3D: Spirit of Vengeance',        movie_id: 123162, released_on: Date.civil(2012, 2, 16)},
  {title: 'The Iron Lady',                              movie_id: 116928, released_on: Date.civil(2012, 2, 01)},
].each do |atts|
  movie_id = atts.delete(:movie_id)
  movie = Movie.create!(atts)
  MovieTickets::MovieSource.create!(movie: movie, external_id: movie_id)
end

# Create AMC theater.
theater = Theater.create!(name: 'AMC Quail Springs Mall 24', address: '2501 West Memorial Road, Oklahoma City, OK, 73134')
MovieTickets::TheaterSource.create! theater: theater, external_id: 5902
