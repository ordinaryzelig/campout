class ChangeTheaterAssignmentsToNotNull < ActiveRecord::Migration
  def change
    change_column :theater_assignments, :movie_tickets_theater_id, :integer, null: false
    change_column :theater_assignments, :twitter_account_id, :integer, null: false
  end
end
