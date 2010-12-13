class AddUrlnamesTable < ActiveRecord::Migration # :nodoc: 

  def self.up
    create_table 'urlnames' do |t|
      t.column 'nameable_type',     :string
      t.column 'nameable_id',       :integer
      t.column 'name',              :string
    end
  end
  
  def self.down
    drop_table 'urlnames'
  end
  
end
