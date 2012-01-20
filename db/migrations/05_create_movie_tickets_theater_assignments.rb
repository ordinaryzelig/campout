class CreateMovieTicketsTheaterAssignments < ActiveRecord::Migration
  def change
    create_table :movie_tickets_theater_assignments do |t|
      t.belongs_to :movie_tickets_theater, null: false
      t.belongs_to :twitter_account, null: false
    end
  end
end
