class CreateTicketNotifications < ActiveRecord::Migration
  def change
    create_table :ticket_notifications do |t|
      t.belongs_to :twitter_account, null: false
      t.belongs_to :movie, null: false
      t.belongs_to :theater, null: false
    end
    add_index :ticket_notifications, [:twitter_account_id, :movie_id, :theater_id], unique: true, name: 'index_ticket_notifications_unique'
  end
end
