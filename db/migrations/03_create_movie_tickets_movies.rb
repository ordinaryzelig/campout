class CreateMovieTicketsMovies < ActiveRecord::Migration
  def change
    create_table :movie_tickets_movies do |t|
      t.string :title, null: false
      t.integer :movie_id, null: false
    end
  end
end
