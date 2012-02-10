class CreateTicketNotifications < ActiveRecord::Migration
  def change
    create_table :ticket_notifications do |t|
      t.belongs_to :twitter_account, null: false
      t.belongs_to :movie, null: false
      t.string :theater_source_type, null: false
      t.string :external_id, null: false
    end
    add_index :ticket_notifications, [:twitter_account_id, :movie_id, :theater_source_type, :external_id], unique: true, name: 'index_ticket_notifications_unique'
    add_index :ticket_notifications, [:twitter_account_id, :movie_id, :theater_source_type], name: 'index_ticket_notifications_for_speed' # Gosh this is a bad name.
  end
end
