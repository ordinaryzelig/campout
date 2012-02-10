class DropMovieTicketsTheaters < ActiveRecord::Migration
  def change
    drop_table :movie_tickets_theaters
  end
end
