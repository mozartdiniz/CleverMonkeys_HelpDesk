class CreateGroupsRole < ActiveRecord::Migration
  def self.up
    create_table :groups_roles do |t|
      t.integer :group_id
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :groups_roles
  end
end
