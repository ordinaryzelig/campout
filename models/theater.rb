# Scouring a theater will return array of movies showing at that theater.

class Theater < ActiveRecord::Base

  has_many :theater_sources
  has_many :theater_assignments
  has_many :twitter_accounts, through: :theater_assignments

  before_validation :create_short_name

  validates :name,       presence: true
  validates :short_name, presence: true

  private

  # Remove extraneous 'theater', 'theatre', 'cinema' (or any plural form), and trailing numbers.
  # I don't care how many screens you have.
  # Got limited tweet characters here, people.
  def create_short_name
    self.short_name = self.name.gsub(/\b(cinema|theater|theatre)s?\b/i, ''). # remove theater, theatre
                                sub(/\d+$/, '').  # remove trailing digits
                                strip.            # remove extraneous white space
                                gsub(/ \s*/, ' ') # replace multiple whitespaces with single space
    self.short_name = name if self.short_name.blank?
  end

end
