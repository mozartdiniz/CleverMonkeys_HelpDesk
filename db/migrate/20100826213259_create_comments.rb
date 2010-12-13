class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :ticket_id
      t.integer :user_id

      t.string :subject, :limit => '200'
      t.text :message

      t.timestamps
    end


  end

  def self.down
    drop_table :comments
  end
end
