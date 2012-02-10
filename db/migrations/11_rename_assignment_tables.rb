class RenameAssignmentTables < ActiveRecord::Migration
  def change
    rename_table :movie_tickets_movie_assignments, :movie_assignments
    rename_column :movie_assignments, :movie_tickets_movie_id, :movie_id
    drop_table :movie_tickets_theater_assignments
  end
end
