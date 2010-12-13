class CreateTicketNotificationUsers < ActiveRecord::Migration
  def self.up
    create_table :ticket_notification_users do |t|
      t.integer :ticket_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_notification_users
  end
end
