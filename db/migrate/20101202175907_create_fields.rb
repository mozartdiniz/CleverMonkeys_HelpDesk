class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.string :field_type, :limit => 10
      t.integer :resource_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fields
  end
end
