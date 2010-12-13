require 'tls_smtp'

class SmtpGmail

  def set_user(params={})
    
    ActionMailer::Base.smtp_settings = {
      :address => "smtp.gmail.com",
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true,
      :user_name => params[:user],
      :password => params[:pass]
    }

  end

end