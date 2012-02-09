class Tracker < ActiveRecord::Base

  belongs_to :twitter_account
  belongs_to :movie_assignment
  belongs_to :theater_assignment
  has_one    :movie,   through: :movie_assignment
  has_one    :theater, through: :theater_assignment

  validates :twitter_account_id,    presence: true
  validates :movie_assignment_id,   presence: true
  validates :theater_assignment_id, presence: true

  scope :live, where(live: true)

  def close
    update_attributes! live: false
  end

end
