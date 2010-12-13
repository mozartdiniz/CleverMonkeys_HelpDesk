class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.integer  :enterprise_id
      t.integer  :user_id
      t.integer  :ticket_status_id
      t.integer  :priority_id
      t.integer  :ticket_type_id
      t.integer  :ticket_number, :auto_increment => true
      t.string   :subject      
      t.text     :issue_description
      t.integer  :assigned_user_id
      t.datetime :due_date
      t.integer  :created_by_id
      t.integer  :template_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end
