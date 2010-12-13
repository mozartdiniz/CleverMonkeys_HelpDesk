class CreateCommentsFiles < ActiveRecord::Migration
  def self.up
    create_table :comments_files do |t|
      t.integer  :comment_id
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size
      t.string   :file_updated_at
      t.string   :cid

      t.timestamps
    end

  end

  def self.down
    drop_table :replies_files
  end
end
