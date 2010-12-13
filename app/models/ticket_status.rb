class TicketStatus < ActiveRecord::Base

  has_many :tickets

  def self.ticket_statuses

    @statuses = TicketStatus.all.collect {|x| [x.translated_description, x.id]}

  end

end