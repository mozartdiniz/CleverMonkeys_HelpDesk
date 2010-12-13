class SendMail < ActionMailer::Base

  def password(pass, name, email)

    smtp_gmail = SmtpGmail.new

    smtp_gmail.set_user(:user => GlobalConfiguration.find_by_key("pro_email").value,
                        :pass => GlobalConfiguration.find_by_key("pro_pass").value)

    recipients    email
    from          "LUMLEY PORTAL"
    subject       'your new password'
    sent_on       Time.now
    content_type "text/html"

    @password = pass

    @name     = name

    template "password"

  end

  def ticket(user, ticket, subject, message)

    smtp_gmail = SmtpGmail.new

    if ENV['RAILS_ENV'] == 'development'

      smtp_gmail.set_user(:user => GlobalConfiguration.find_by_key("dev_email").value,
                          :pass => GlobalConfiguration.find_by_key("dev_pass").value)
    else

      smtp_gmail.set_user(:user => GlobalConfiguration.find_by_key("pro_email").value,
                          :pass => GlobalConfiguration.find_by_key("pro_pass").value)
    end

    recipients    user.email
    from          "LUMLEY PORTAL"
    subject       "Your ticket (#{ticket.ticket_number}) has a new comment"
    sent_on       Time.now
    content_type "text/html"

    @subject = "Your ticket (#{ticket.ticket_number}) has a new comment - " + subject
    @from    = 'ticket@lumleytech.com'
    @assunto = subject
    @user    = user
    @ticket  = ticket
    @message = message
    @issue_description = ticket.issue_description

    template 'ticket'

  end

  def ticket_copy(ticket_id)

    smtp_gmail = SmtpGmail.new

    if ENV['RAILS_ENV'] == 'development'

      smtp_gmail.set_user(:user => GlobalConfiguration.find_by_key("dev_email").value,
                          :pass => GlobalConfiguration.find_by_key("dev_pass").value)
    else

      smtp_gmail.set_user(:user => GlobalConfiguration.find_by_key("pro_email").value,
                          :pass => GlobalConfiguration.find_by_key("pro_pass").value)
    end

    @ticket  = Ticket.find ticket_id
    @user    = User.find @ticket.user_id
    @company = Enterprise.find(@user.enterprise_id)

    if @company.send_ticket_mail_for_all_company == false
      recipients    @user.email
    else
      if @company.send_ticket_mail_for_all_company.nil?
        recipients    @user.email
      else
        recipients    @company.email
      end
    end
    
    from          "LUMLEY PORTAL"
    subject       "This is your copy from ticket #{@ticket.ticket_number}"
    sent_on       Time.now
    content_type "text/html"

    template 'ticket_copy'
    
  end

end