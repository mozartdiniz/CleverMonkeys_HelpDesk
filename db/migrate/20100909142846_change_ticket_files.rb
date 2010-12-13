class ChangeTicketFiles < ActiveRecord::Migration
  def self.up
    create_table :ticket_files do |t|
      t.integer :ticket_id
      t.string  :file_file_name
      t.string  :file_content_type
      t.string  :file_file_size
      t.string  :file_updated_at
      t.string  :cid
      t.integer :file_size

      t.timestamps
    end
  end

  def self.down

    drop_table :ticket_files

  end
end
