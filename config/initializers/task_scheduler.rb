require 'rubygems'
require 'rufus/scheduler'
require 'net/pop'
require 'tmail'
require 'tmail_mail_extension'

scheduler = Rufus::Scheduler.start_new

scheduler.every '20s' do
  
    Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)

    if ENV['RAILS_ENV'] == 'development'
      host          = GlobalConfiguration.find_by_key("dev_host").value
      port          = GlobalConfiguration.find_by_key("dev_port").value.to_i
      email_account = GlobalConfiguration.find_by_key("dev_email").value
      pass          = GlobalConfiguration.find_by_key("dev_pass").value
    else
      host          = GlobalConfiguration.find_by_key("pro_host").value
      port          = GlobalConfiguration.find_by_key("pro_port").value.to_i
      email_account = GlobalConfiguration.find_by_key("pro_email").value
      pass          = GlobalConfiguration.find_by_key("pro_pass").value
    end
    
    Net::POP3.start(host, port, email_account, pass) do |pop|

        if pop.mails.empty?

        else
          pop.each_mail do |m|

            email = TMail::Mail.parse(m.pop)

            from      = email.from
            to        = email.to
            subject   = email.subject
            body      = email.body_html.nil? ? email.body : email.body_html

            your_ticket_index = subject.index('Your ticket (')

            subject_index    = subject.index('new comment - ')

            unless subject_index.nil?
              ticket_subject   = "Re: " + subject[(subject_index+14)..(subject.size)]
            else
              ticket_subject   = subject
            end

            @noreply_index = body.index(email_account)

            unless @noreply_index.nil?
              ticket_body      = body[0..(@noreply_index-18)]
            else
              ticket_body      = body
            end

            ticket_user      = from[0][/([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})/]

            user             = User.first :conditions => {:email => ticket_user}

            user_id          = user.id unless user.nil?

            unless your_ticket_index.nil?

              begin_index_ticket = subject.index('Your ticket (')

              after_index_ticket = subject.index(')')

              ticket_number    = subject[(begin_index_ticket+13)..(after_index_ticket-1)].to_i

              ticket_id        = Ticket.find_by_ticket_number(ticket_number).id

              already_exists_this_comment = Comment.first :conditions => {
                :ticket_id => ticket_id,
                :subject   => subject,
                :user_id   => user_id,
                :message   => body
              }

              if already_exists_this_comment.nil?

                comment = Comment.new

                comment.ticket_id = ticket_id
                comment.subject   = ticket_subject
                comment.user_id   = user_id
                comment.message   = ticket_body

                if comment.save

                  if email.has_attachments?

                     email.parts.each_with_index do |part, index|

                          create_comment_file(part, index, comment)

                      end

                   else
                
                     email.parts.each_with_index do |part, index|

                        mais_partes = part.parts

                        unless mais_partes.nil?

                           mais_partes.each do |part2, index2|

                              create_comment_file(part2, index2, comment)

                           end
                        end
                      end

                   end

                  comment.send_mail
                  
                end

              end

            else

                enterprise_id  = user.enterprise_id  unless user.nil?

                ticket = Ticket.create(
                              :enterprise_id          => enterprise_id,
                              :user_id                => user_id,
                              :created_by_id          => user_id,
                              :subject                => subject,
                              :issue_description      => ticket_body,                              
                              :priority_id            => 1
                              )

              if email.has_attachments?

                 email.parts.each_with_index do |part, index|

                    create_ticket_file(part, index, ticket)

                  end

               else
                 
                 email.parts.each_with_index do |part, index|

                    mais_partes = part.parts

                    unless mais_partes.nil?

                       mais_partes.each do |part2, index2|

                          create_ticket_file(part2, index2, ticket)

                       end
                    end                    
                  end
               end
            end
          end
        end
    end
end

def create_comment_file(part, index, comment)

  comment_file = CommentsFile.new

  cid = part.header['x-attachment-id']

  if cid.nil?

    cid = part.header['content-id']

  end

  filename = part_filename(part)

  content_type = part.content_type
  filename ||= "#{index}.#{ext(part)}"
  file = filename
  fname       = file.split(".")
  newfilename = fname[0] + '.' + fname[1]

  unless fname[0].to_i == index

    comment_file.comment_id        = comment.id
    comment_file.file_file_name    = newfilename
    comment_file.file_content_type = content_type
    comment_file.file_updated_at   = Time.now.to_s
    comment_file.cid               = cid.body unless cid.nil?

    if comment_file.save

      dir_path = "#{RAILS_ROOT}/public/images/comments_files/files/#{comment_file.id}/"
      filepath = "#{RAILS_ROOT}/public/images/comments_files/files/#{comment_file.id}/#{newfilename}"

      FileUtils.mkdir_p(dir_path)
      File.open(filepath,'wb'){|f| f.write(part.body)}

      filesize = File.size(filepath)

      comment_file.file_file_size = filesize
      
      comment_file.save

    end

  end

end

def create_ticket_file(part, index, ticket)

    ticket_file = TicketFile.new

    cid = part.header['x-attachment-id']

    if cid.nil?

      cid = part.header['content-id']

    end

    filename = part_filename(part)

    content_type = part.content_type
    filename ||= "#{index}.#{ext(part)}"
    file = filename
    fname       = file.split(".")
    newfilename = fname[0] + '.' + fname[1]

    unless fname[0].to_i == index

      ticket_file.ticket_id         = ticket.id
      ticket_file.file_file_name    = newfilename
      ticket_file.file_content_type = content_type
      ticket_file.file_updated_at   = Time.now.to_s
      ticket_file.cid               = cid.body unless cid.nil?

      if ticket_file.save

        dir_path = "#{RAILS_ROOT}/public/images/ticket_files/files/#{ticket_file.id}/"
        filepath = "#{RAILS_ROOT}/public/images/ticket_files/files/#{ticket_file.id}/#{newfilename}"

        FileUtils.mkdir_p(dir_path)
        File.open(filepath,'wb'){|f| f.write(part.body)}

        filesize = File.size(filepath)

        ticket_file.file_file_size = filesize

        ticket_file.save

      end

    end

end

def part_filename(part)
     file_name = (part['content-location'] &&
     part['content-location'].body) ||
     part.sub_header("content-type", "name") ||
     part.sub_header("content-disposition", "filename")
end

CTYPE_TO_EXT = {
     'image/jpeg' => 'jpg',
     'image/gif' => 'gif',
     'image/png' => 'png',
     'image/tiff' => 'tif'
}

def ext( mail )
     CTYPE_TO_EXT[mail.content_type] || 'txt'
end