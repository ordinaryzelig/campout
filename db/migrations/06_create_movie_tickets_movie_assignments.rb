class CreateMovieTicketsMovieAssignments < ActiveRecord::Migration
  def change
    create_table :movie_tickets_movie_assignments do |t|
      t.belongs_to :movie_tickets_movie, null: false
      t.belongs_to :twitter_account, null: false
    end
  end
end
