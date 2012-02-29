# This used mainly for test rake tasks.

# Create some movies.
[
  {title: 'The Dark Knight Rises: The IMAX Experience', movie_tickets_movie_id: 119747, fandango_movie_id: '148958', released_on: Date.civil(2012, 7, 19)},
  {title: 'The Dark Knight Rises',                      movie_tickets_movie_id: 117274, fandango_movie_id: '135740', released_on: Date.civil(2012, 7, 19)},
].each do |atts|
  movie_tickets_movie_id = atts.delete(:movie_tickets_movie_id)
  fandango_movie_id = atts.delete(:fandango_movie_id)
  movie = Movie.create!(atts)
  MovieTickets::MovieSource.create!(movie: movie, external_id: movie_tickets_movie_id)
  Fandango::MovieSource.create!(movie: movie, external_id: fandango_movie_id)
end

# Create AMC theater.
theater = Theater.create!(name: 'AMC Quail Springs Mall 24', address: '2501 West Memorial Road, Oklahoma City, OK, 73134')
MovieTickets::TheaterSource.create! theater: theater, external_id: 5902
