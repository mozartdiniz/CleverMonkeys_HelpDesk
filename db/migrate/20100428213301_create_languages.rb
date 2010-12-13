class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      
      t.string :description, :limit => 55
      t.string :iso, :limit => 6
      t.boolean :default_language
      t.timestamps
      
    end   
    
  end

  def self.down
    drop_table :languages
  end
end
