class MovieSource < ActiveRecord::Base

  belongs_to :movie

  validates :movie_id, presence: true, uniqueness: {scope: :type}
  validates :external_id, presence: true, uniqueness: {scope: :type}

  delegate :title,       to: :movie
  delegate :released_on, to: :movie

  # Compare using type and external_id.
  # Sometimes the movie source may not be persisted.
  def ==(other_movie_source)
    type == other_movie_source.type && external_id.to_s == other_movie_source.external_id.to_s
  end

end
