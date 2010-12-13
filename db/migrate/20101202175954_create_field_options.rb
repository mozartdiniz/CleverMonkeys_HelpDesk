class CreateFieldOptions < ActiveRecord::Migration
  def self.up
    create_table :field_options do |t|
      t.integer :field_id
      t.integer :resource_id

      t.timestamps
    end
  end

  def self.down
    drop_table :field_options
  end
end
