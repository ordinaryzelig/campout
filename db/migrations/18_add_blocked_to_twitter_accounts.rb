class AddBlockedToTwitterAccounts < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :blocked, :boolean, default: false, null: false
  end
end
