class Enterprise < ActiveRecord::Base

  has_many :tickets
  has_many :users

  belongs_to :country

  validates_presence_of :name

  named_scope :clients, :conditions => {:is_your_company => false}

  def has_ticket_default_values

    tdv = TicketsDefault.find_by_enterprise_id self.id

    if tdv.nil? || tdv.blank?
       return 'NO'
    else
      return 'YES'
    end

  end

end
