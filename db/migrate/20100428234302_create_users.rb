class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name, :limit => 55
      t.string :display_name, :limit => 40
      t.string :phone_number, :limit => 25
      t.string :mobile_number, :limit => 25
      t.string :email
      t.string :hashed_password, :null => false
      t.string :salt, :null => false
      t.integer :group_id
      t.integer :language_id
      t.integer :enterprise_id

      t.string :photo_file_name
      t.string :photo_content_type
      t.string :photo_file_size
      t.string :photo_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end