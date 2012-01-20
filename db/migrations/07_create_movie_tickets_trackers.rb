class CreateMovieTicketsTrackers < ActiveRecord::Migration
  def change
    create_table :movie_tickets_trackers do |t|
      t.belongs_to :twitter_account, null: false
      t.belongs_to :movie_tickets_movie_assignment, null: false
      t.belongs_to :movie_tickets_theater_assignment, null: false
    end
  end
end
