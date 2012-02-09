class RenameAssignmentTables < ActiveRecord::Migration
  def change
    rename_table :movie_tickets_movie_assignments, :movie_assignments
    rename_table :movie_tickets_theater_assignments, :theater_assignments
    rename_column :movie_assignments, :movie_tickets_movie_id, :movie_id
    rename_column :theater_assignments, :movie_tickets_theater_id, :theater_id
  end
end
