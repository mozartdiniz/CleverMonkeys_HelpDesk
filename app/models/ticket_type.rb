class TicketType < ActiveRecord::Base
  has_many :tickets
end
