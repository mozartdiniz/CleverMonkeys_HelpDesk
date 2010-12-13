class CreateRightsRoles < ActiveRecord::Migration
  def self.up
    create_table :rights_roles do |t|
      t.integer :role_id
      t.integer :right_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rights_roles
  end
end
