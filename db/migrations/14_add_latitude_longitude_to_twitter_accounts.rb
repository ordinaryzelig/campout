class AddLatitudeLongitudeToTwitterAccounts < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :latitude, :float
    add_column :twitter_accounts, :longitude, :float
    add_index :twitter_accounts, [:latitude, :longitude]
  end
end
