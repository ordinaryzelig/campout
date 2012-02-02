class ChangeTwitterAccountsZipcodeToString < ActiveRecord::Migration

  def change
    change_column :twitter_accounts, :zipcode, :string
  end

end
