class CreateTicketsDefaults < ActiveRecord::Migration
  def self.up
    create_table :tickets_defaults do |t|
      
      t.integer  :enterprise_id
      t.integer  :di_os_version
      t.integer  :di_database_info
      t.integer  :rts_database_info
      t.integer  :rts_versions_id
      t.string   :language_id,        :limit => '4'
      t.string   :di_version,         :limit => '100'
      t.string   :device_version,     :limit => '100'

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets_defaults
  end
end
