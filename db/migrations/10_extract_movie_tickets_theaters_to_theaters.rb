class ExtractMovieTicketsTheatersToTheaters < ActiveRecord::Migration
  def change
    # Create theaters table.
    create_table :theaters do |t|
      t.string :name, null: false
      t.string :short_name, null: false
      t.integer :old_house_id
      t.timestamps
    end
    # Migrate movie_tickets_theaters data to theaters table.
    execute <<-END
      INSERT INTO theaters (name, short_name, old_house_id, created_at, updated_at)
        SELECT name, short_name, house_id, created_at, updated_at
        FROM movie_tickets_theaters
    END
    # Rename movie_tickets_theaters to theater_sources.
    rename_table :movie_tickets_theaters, :theater_sources
    # Add theater_sources.type (STI) column.
    add_column    :theater_sources, :type, :string
    # Rename theater_sources.house_id to external_id.
    rename_column :theater_sources, :house_id, :external_id
    # Add theater_sources.theater_id column.
    add_column    :theater_sources, :theater_id, :integer
    # Add unique index to external_id and type
    add_index :theater_sources, [:external_id, :type], unique: true
    # Add unique index to theater_id and type
    add_index :theater_sources, [:theater_id, :type], unique: true
    # Set all existing theater_sources type to 'TheaterTickets::Theater'.
    execute <<-END
      UPDATE theater_sources
      SET
        type = 'MovieTickets::Theater',
        theater_id = (SELECT theaters.id FROM theaters WHERE theaters.old_house_id = theater_sources.external_id)
    END
    # Change external_id to string.
    change_column :theater_sources, :external_id, :string, null: false
    # Change some columns to not NULL.
    change_column :theater_sources, :type, :string, null: false
    change_column :theater_sources, :theater_id, :integer, null: false
    # Remove name and short_name columns.
    [:name, :short_name].each do |column|
      remove_column :theater_sources, column
    end
    # Remove theaters.old_house_id.
    remove_column :theaters, :old_house_id
  end
end
