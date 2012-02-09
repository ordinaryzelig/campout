class MovieSource < ActiveRecord::Base

  belongs_to :movie

  validates :movie_id, presence: true, uniqueness: {scope: :type}
  validates :external_id, presence: true, uniqueness: {scope: :type}

  delegate :title,       to: :movie
  delegate :released_on, to: :movie

end
