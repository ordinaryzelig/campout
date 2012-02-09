class TheaterSource < ActiveRecord::Base

  belongs_to :theater

  validates :theater_id, presence: true, uniqueness: {scope: :type}
  validates :external_id, presence: true, uniqueness: {scope: :type}

  delegate :name,       to: :theater
  delegate :short_name, to: :theater

end
