class AddTheatersAssignedToTwitterAccounts < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :theaters_assigned, :boolean, null: false, default: false
  end
end
