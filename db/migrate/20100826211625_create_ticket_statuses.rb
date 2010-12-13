class CreateTicketStatuses < ActiveRecord::Migration
  def self.up
    create_table :ticket_statuses do |t|
      t.string :description, :limit => '45'

      t.timestamps
    end
  end

  def self.down
    drop_table :ticket_statuses
  end
end
