class RenameTwitterAccountsZipcodeToPostalCode < ActiveRecord::Migration
  def change
    rename_column :twitter_accounts, :zipcode, :postal_code
    rename_column :twitter_accounts, :prompted_for_zipcode_at, :prompted_for_postal_code_at
  end
end
