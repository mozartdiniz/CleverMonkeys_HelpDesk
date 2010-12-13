class CreateTemplateFields < ActiveRecord::Migration
  def self.up
    create_table :template_fields do |t|
      t.integer :template_id
      t.integer :field_id
      t.string :width, :limit => 10
      t.integer :field_order
      t.string :height, :limit => 10
      t.boolean :mandatory
      t.integer :resource_id

      t.timestamps
    end
  end

  def self.down
    drop_table :template_fields
  end
end
