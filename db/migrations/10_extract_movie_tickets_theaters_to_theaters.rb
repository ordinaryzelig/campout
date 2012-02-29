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
      t.timestamps
    end
    add_index :theaters, :country
    add_index :theaters, [:latitude, :longitude]
    # Rename movie_tickets_theaters to theater_sources.
    rename_table :movie_tickets_theaters, :theater_sources
    # Empty theater_sources table.
    execute 'DELETE from theater_sources'
    # Add theater_sources.type (STI) column.
    add_column :theater_sources, :type, :string
    # Add theater_id column to reference new theaters table.
    add_column :theater_sources, :theater_id, :integer
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
