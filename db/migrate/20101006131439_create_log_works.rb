class CreateLogWorks < ActiveRecord::Migration
  def self.up
    create_table :log_works do |t|
      t.integer  :ticket_id
      t.integer  :user_id
      t.integer  :time_spend
      t.datetime :start_date
      t.text     :description

      t.timestamps
    end
  end

  def self.down
    drop_table :log_works
  end
end
