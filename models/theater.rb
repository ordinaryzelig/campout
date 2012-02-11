class Theater < ActiveRecord::Base

  has_many :theater_sources

  validates :name, presence: true

  def short_name
    @short_name ||= name.to_theater_short_name
  end

end
