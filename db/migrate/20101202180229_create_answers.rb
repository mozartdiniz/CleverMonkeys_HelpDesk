class CreateAnswers < ActiveRecord::Migration
  def self.up
    create_table :answers do |t|
      t.string :value
      t.integer :ticket_id
      t.integer :template_field_id

      t.timestamps
    end
  end

  def self.down
    drop_table :answers
  end
end
