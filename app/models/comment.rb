class Comment < ActiveRecord::Base

  after_create :add_user_to_notification_list

  belongs_to :ticket
  belongs_to :user

  has_many :comments_files

  def add_user_to_notification_list

    @ticket_user = TicketNotificationUser.all :conditions => {
                                                    :user_id => self.user_id,
                                                    :ticket_id => self.ticket_id
                                                    }


    if @ticket_user.blank?

      TicketNotificationUser.create(:user_id => self.user_id,
                                    :ticket_id => self.ticket_id)
    end

  end

  def send_mail

    @user_list = TicketNotificationUser.all :conditions => {:ticket_id => self.ticket_id}

    @user_list.each do |u|

      unless u.user_id == self.user_id

        user   = User.find u.user_id

        ticket = Ticket.find self.ticket_id

        SendMail.deliver_ticket(user, ticket, self.subject, self.message)

      end

    end

  end

end
