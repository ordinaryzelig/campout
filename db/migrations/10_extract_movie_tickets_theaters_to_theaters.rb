class ExtractMovieTicketsTheatersToTheaters < ActiveRecord::Migration
  def change
    # Create theaters table.
    create_table :theaters do |t|
      t.string  :name, null: false
      t.string  :address
      t.string  :postal_code
      t.string  :country
      t.float   :latitude
      t.float   :longitude
      t.integer :old_house_id, null: false
      t.timestamps
    end
    add_index :theaters, :country
    add_index :theaters, [:latitude, :longitude]
    # Migrate movie_tickets_theaters data to theaters table.
    execute <<-END
      INSERT INTO theaters (name, old_house_id, created_at, updated_at)
        SELECT name, house_id, created_at, updated_at
        FROM movie_tickets_theaters
    END
    # Rename movie_tickets_theaters to theater_sources.
    rename_table :movie_tickets_theaters, :theater_sources
    # Add theater_sources.type (STI) column.
    add_column :theater_sources, :type, :string
    # Add theater_id column to reference new theaters table.
    add_column :theater_sources, :theater_id, :integer
    # Set all existing theater_sources type to 'MovieTickets::TheaterSource'
    # Assign theater_id to matching theater.
    execute <<-END
      UPDATE theater_sources
      SET
        type = 'MovieTickets::TheaterSource',
        theater_id = (SELECT theaters.id FROM theaters where theaters.old_house_id = theater_sources.house_id)
    END
    # Remove theaters.old_house_id columns.
    remove_column :theaters, :old_house_id
    # Change some columns to not NULL.
    change_column :theater_sources, :type, :string, null: false
    change_column :theater_sources, :theater_id, :integer, null: false
    # Remove theater_sources.name, short_name column.
    [:name, :short_name].each do |column|
      remove_column :theater_sources, column
    end
    # Rename theater_sources.house_id to external_id string.
    rename_column :theater_sources, :house_id, :external_id
    change_column :theater_sources, :external_id, :string, null: false
    # Add unique index to external_id and type
    add_index :theater_sources, [:external_id, :type], unique: true
  end
end
