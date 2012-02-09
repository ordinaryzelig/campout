class RenameMovieTicketsTrackersToTrackers < ActiveRecord::Migration
  def change
    rename_table :movie_tickets_trackers, :trackers
    rename_column :trackers, :movie_tickets_movie_assignment_id, :movie_assignment_id
    rename_column :trackers, :movie_tickets_theater_assignment_id, :theater_assignment_id
  end
end
