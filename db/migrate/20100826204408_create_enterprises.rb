class CreateEnterprises < ActiveRecord::Migration
  def self.up
    create_table :enterprises do |t|
      t.string   :name, :limit => '45'
      t.boolean  :is_your_company
      t.string   :email, :limit => '100'
      t.string   :phone_01, :limit => '45'
      t.string   :phone_02, :limit => '45'
      t.string   :other_email, :limit => '100'
      t.boolean  :enabled
      t.boolean  :send_ticket_mail_for_all_company
      t.integer  :country_id

      t.timestamps
    end
  end

  def self.down
    drop_table :enterprises
  end
end
