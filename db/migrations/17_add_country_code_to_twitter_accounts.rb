class AddCountryCodeToTwitterAccounts < ActiveRecord::Migration
  def change
    add_column :twitter_accounts, :country_code, :string
  end
end
