class CreateTheaterAssignments < ActiveRecord::Migration
  def change
    create_table :theater_assignments do |t|
      t.belongs_to :movie_tickets_theater
      t.belongs_to :twitter_account
    end
  end
end
