class ExtractMovieTicketsMoviesToMovies < ActiveRecord::Migration
  def change
    # Create movies table.
    create_table :movies do |t|
      t.string  :title, null: false
      t.date    :released_on, null: false
      t.timestamps
    end
    # Migrate movie_tickets_movies data to movies table.
    execute <<-END
      INSERT INTO movies (title, released_on, created_at, updated_at)
        SELECT title, released_on, created_at, updated_at
        FROM movie_tickets_movies
    END
    # Rename movie_tickets_movies to movie_sources.
    rename_table :movie_tickets_movies, :movie_sources
    # Add movie_sources.type (STI) column.
    add_column :movie_sources, :type, :string
    # Rename movie_sources.movie_id to external_id and change to string.
    rename_column :movie_sources, :movie_id, :external_id
    change_column :movie_sources, :external_id, :string, null: false
    # Add movie_id column (different than movie_id column above that was changed to external_id).
    add_column :movie_sources, :movie_id, :integer
    # Add unique index to external_id and type
    add_index :movie_sources, [:external_id, :type], unique: true
    # Add unique index to movie_id and type
    add_index :movie_sources, [:movie_id, :type], unique: true
    # Set all existing movie_sources type to 'MovieTickets::Movie'
    # Assign movie_id to matching movie.
    execute <<-END
      UPDATE movie_sources
      SET
        type = 'MovieTickets::Movie',
        movie_id = (SELECT movies.id FROM movies where movies.title = movie_sources.title)
    END
    # Change some columns to not NULL.
    change_column :movie_sources, :type, :string, null: false
    change_column :movie_sources, :movie_id, :integer, null: false
    # Remove title and released_on columns.
    [:title, :released_on].each do |column|
      remove_column :movie_sources, column
    end
  end
end
