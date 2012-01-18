class CreateTwitterAccounts < ActiveRecord::Migration

  def change
    create_table :twitter_accounts do |t|
      t.integer  :user_id, null: false
      t.string   :screen_name, null: false
      t.boolean  :followed, null: false, default: false
      t.integer  :zipcode
      t.datetime :prompted_for_zipcode_at
      t.string   :location
    end
  end

end
