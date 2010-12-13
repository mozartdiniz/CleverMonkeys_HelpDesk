module TicketsHelper

  def priority_generator(priority_id)

    html = ""

    if priority_id == 1
      html << "<img border='0' src='/images/priority_low.png' />"
    else
      if priority_id == 2
        html << "<img border='0' src='/images/priority_normal.png' />"
      else
        if priority_id == 3
          html << "<img border='0' src='/images/priority_high.png' />"
        else
          html << "<img border='0' src='/images/priority_block.png' />"
        end
      end

    end

    return html

  end

  def ticket_status_generator(ticket)

    status = "<div class='ticket_status'>"

    #- Open - Created, not assigned, not worked
    #- Assigned
    #- working
    #- Closed
    #- Cancelled
    #- Resolved
    #- Reopened

    if ticket.ticket_status.nil?

      if ticket.assigned_user_id.nil?
        status << "#{I18n.t "views.ticket.status_generator.open"}"
      else
        unless ticket.log_works.blank?
          status << "#{I18n.t "views.ticket.status_generator.working"}"
        else
          status << "#{I18n.t "views.ticket.status_generator.assigned"}"
        end
      end
      
    else

      ticket_status = TicketStatus.find(:first, :conditions => {:id => ticket.ticket_status_id})

      unless ticket_status.nil?

        status << ticket_status.description

      end

    end

    status << "</div>"

    return status
    
  end

  def ticket_image_inline(ticket)

    issue_description = ticket.issue_description

    images = ticket.ticket_files.each do |f|

      unless issue_description.nil?

        if f.file_content_type.include? 'image'

          if f.cid.nil?
            issue_description = issue_description.gsub(/[a-zA-Z]*: #{f.file_file_name}/, "<img src='/images/ticket_files/files/#{f.id}/#{f.file_file_name}' border='0' />")
            issue_description = issue_description.gsub("\n", "<br />")
          else

            x = f.cid.gsub(/[<>]/, '')

            issue_description = issue_description.gsub("cid:#{x}", "/images/ticket_files/files/#{f.id}/#{f.file_file_name}")
          end

        end

      end

    end

    return issue_description

  end

  def comment_image_inline(comment)

    # "Attachment: priority_block.png"

    message = comment.message

    comment.comments_files.each do |c|

      unless message.nil?

        if c.file_content_type.include? 'image'

          if c.cid.nil?
            message = message.gsub(/[a-zA-Z]*: #{c.file_file_name}/, "<img src='/images/comments_files/files/#{c.id}/#{c.file_file_name}' border='0' />")
            message = message.gsub("\n", "<br />")
          else            
            x = c.cid.gsub(/[<>]/, '')

            message = message.gsub("cid:#{x}", "/images/comments_files/files/#{c.id}/#{c.file_file_name}")
          end
          
        end

      end

    end

    return message

  end

  def enterprise_list_generator

  #<select>
  #  <optgroup label="Swedish Cars">
  #    <option value="volvo">Volvo</option>
  #    <option value="saab">Saab</option>
  #  </optgroup>
  #  <optgroup label="German Cars">
  #    <option value="mercedes">Mercedes</option>
  #    <option value="audi">Audi</option>
  #  </optgroup>
  #</select>

   @enterprise = Enterprise.find(:all, :conditions => ["is_your_company is not true"], :order => "name ASC")

   html = ""

   @enterprise.each do |e|

      html << "<optgroup label='#{e.name}'>"

      e.users.each do |u|

        html << "<option value='#{u.id}' >#{u.display_name.nil? ? u.name : u.display_name}</option>"

      end

      html << "</optgroup>"

   end

   return html

    #   @customers, {}, {:onchange => " #{ remote_function :url => {:action => 'ticket_default_values'},
    #                                                               :update => 'ticket_default_values',
    #                                                               :before => "$('loading_defaults').show()",
    #                                                               :complete => "$('loading_defaults').hide()",
    #                                                               :with => "this.name + '=' + this.value" } #"}

  end


end
