class SeedStatusData < ActiveRecord::Migration
  def self.up
    TicketStatus.create(:description => "Closed")
    TicketStatus.create(:description => "Cancelled")
    TicketStatus.create(:description => "Resolved")
    TicketStatus.create(:description => "Reopened")
    TicketStatus.create(:description => "Forwarded")
  end

  def self.down
    TicketStatus.find_by_description(:description => "Closed").destroy
    TicketStatus.find_by_description(:description => "Cancelled").destroy
    TicketStatus.find_by_description(:description => "Resolved").destroy
    TicketStatus.find_by_description(:description => "Reopened").destroy
    TicketStatus.find_by_description(:description => "Forwarded").destroy
  end
end
