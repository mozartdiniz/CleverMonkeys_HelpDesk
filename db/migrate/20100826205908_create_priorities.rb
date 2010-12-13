class CreatePriorities < ActiveRecord::Migration
  def self.up
    create_table :priorities do |t|
      t.string :description, :limit => '45'

      t.timestamps
    end
  end

  def self.down
    drop_table :priorities
  end
end
