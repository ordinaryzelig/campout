class DropMovieTicketsTrackers < ActiveRecord::Migration
  def change
    drop_table :movie_tickets_trackers
  end
end
