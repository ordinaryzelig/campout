# Given a set of trackers, compose a tweet string with
# message that movie is on sale at theaters.
# Use theater.short_name and truncate equally across theater names.

class TicketsOnSaleTweet < TweetString

  MOVIE_TITLE_MAX_LENGTH = 30

  def initialize(movie, theaters)
    # Compose movie title + 'is on sale at '.
    truncated_movie_title = movie.title.truncate(MOVIE_TITLE_MAX_LENGTH)
    is_on_sale_at = ' is on sale at '
    tweet = TweetString.new("#{truncated_movie_title}#{is_on_sale_at}")
    # compose list of theaters with truncated names.
    chars_per_theater = (tweet.num_chars_left / theaters.size) - 2 # For comma and space.
    truncated_theater_names = theaters.map { |theater| theater.short_name.truncate(chars_per_theater) }.join(', ')
    # Combine.
    tweet += truncated_theater_names
    # Fill up empty space with extra chars from truncated movie title.
    if truncated_movie_title.length < movie.title.length && tweet.num_chars_left > 0
      truncated_movie_title = movie.title.truncate(MOVIE_TITLE_MAX_LENGTH + tweet.num_chars_left)
      tweet = truncated_movie_title + is_on_sale_at + truncated_theater_names
    end
    super tweet
  end

end
