class CreateInitialPriorities < ActiveRecord::Migration
  def self.up
    Priority.create(:description => "Low")
    Priority.create(:description => "Normal")
    Priority.create(:description => "High")
    Priority.create(:description => "Block")
  end

  def self.down
    Priority.find_by_description("Low").destroy
    Priority.find_by_description("Normal").destroy
    Priority.find_by_description("High").destroy
    Priority.find_by_description("Block").destroy
  end
end
