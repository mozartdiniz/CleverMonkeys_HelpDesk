class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.integer :resource_id
      t.integer :language_id
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :translations
  end
end
