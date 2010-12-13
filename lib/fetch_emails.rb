#require 'net/pop'
#require 'tmail'
#
#class FetchEmails
#
#    def get_email
#
#        Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
#
#        emails = Array.new
#
#        Net::POP3.start('pop.gmail.com', 995, 'ticket@lumleytech.com', 'pl3as3c4llus') do |pop|
#
#            if pop.mails.empty?
#              emails = nil
#            else
#              pop.each_mail do |mail|
#                emails.push self.clear_email(mail)
#              end
#            end
#
#        end
#
#        return emails
#
#    end
#
#    def clear_email(mail)
#
#        email = TMail::Mail.parse(mail.pop)
#
#        #o TO ele faz um Array!!!
#
#        email  = {:subject => email.subject,
#                  :from => email.from,
#                  :to => email.to,
#                  :body => email.body,
#                  :original => mail.pop
#                  }
#
#        return email
#
#    end
#
#end
