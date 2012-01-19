class CreateMovieTicketsTheaters < ActiveRecord::Migration
  def change
    create_table :movie_tickets_theaters do |t|
      t.string  :name, null: false
      t.integer :house_id, null: false
      t.timestamps
    end
  end
end
