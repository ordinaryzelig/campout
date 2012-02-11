class TheaterSource < ActiveRecord::Base

  belongs_to :theater

  validates :theater_id, presence: true
  validates :external_id, presence: true

end
