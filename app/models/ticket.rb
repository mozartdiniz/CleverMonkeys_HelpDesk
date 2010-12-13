class Ticket < ActiveRecord::Base
 
  before_create :create_ticket_number

  before_save :set_enterprise

  after_create  :add_user_to_notification_list

  has_many   :comments
  has_many   :ticket_files
  has_many   :ticket_notification_users
  has_many   :log_works

  belongs_to :ticket_status
  belongs_to :ticket_note
  belongs_to :priority
  belongs_to :enterprise
  belongs_to :user
  belongs_to :ticket_type

  validates_presence_of :subject

  def create_ticket_number

    current_number = Ticket.find(:last, :order => 'ticket_number ASC')

    unless current_number.nil?
      self.ticket_number = current_number.ticket_number + 1
    else
      self.ticket_number = 1
    end

  end


  def assignee

    unless self.assigned_user_id.nil?
      u =  User.find(:first, :conditions => {:id => self.assigned_user_id})

      unless u.nil?
        return u.display_name
      else
        return ""
      end
    else
      return ""
    end

  end


  def self.filter(options={})

    unless options[:assigned_user_id].blank?
      assigned_user_id = "and t.assigned_user_id = #{options[:assigned_user_id]}"
    else
      assigned_user_id = ""
    end

    unless options[:di_version].blank?
      di_version = "and t.di_version like '%#{options[:di_version]}%'"
    else
      di_version = ""
    end

    unless options[:priority_id].blank?
      priority_id = "and t.priority_id like '%#{options[:priority_id]}%'"
    else
      priority_id = ""
    end

    unless options[:ticket_number].blank?
      ticket_number = "and t.ticket_number like '%#{options[:ticket_number]}%'"
    else
      ticket_number = ""
    end

    unless options[:rts_version].blank?
      rts_version = "and r.version like '%#{options[:rts_version]}%'"
    else
      rts_version = ""
    end

    unless options[:status_id].blank?
      if options[:status_id] == 'open'
        status_id = "and t.assigned_user_id is null"
      else
        if options[:status_id] == 'working'
          status_id = "and t.assigned_user_id is not null
                       and (t.ticket_status_id is null or t.ticket_status_id = 4)"
        else
          status_id = "and t.ticket_status_id in (select id from ticket_statuses t where t.description = 'Closed' or t.description = 'Cancelled' or t.description = 'Resolved' or t.description = 'Forwarded')"
        end
      end
    else
      status_id = ""
    end

    unless options[:enterprise_id].blank?
      enterprise = "and t.enterprise_id = #{options[:enterprise_id]}"
    else
      enterprise = ""
    end

    #@chips = Chip.paginate :page => params[:page], :conditions => "telco_id='#{params[:filter]['telco_id']}' and imei LIKE '%#{params[:filter]['imei']}%' and number LIKE '%#{params[:filter]['number']}%' #{can_make_call} #{can_send_sms} #{can_recieve_call} #{can_use_data_network} #{blocked_since}", :order => 'imei ASC'

    sql = "select t.id, t.issue_description, t.subject, t.enterprise_id, t.user_id, t.ticket_status_id, t.ticket_number, t.assigned_user_id, t.created_at, t.priority_id,  ts.description as 'ticket_statuses', e.name 'enterprise_name', u.name 'user'
           from tickets t
           left outer join ticket_statuses ts
           on ts.id = t.ticket_status_id
           left outer join users u
           on u.id = t.user_id
           left outer join enterprises e
           on e.id = u.enterprise_id
           where t.subject like '%#{options[:subject]}%'
           #{assigned_user_id}
           #{di_version}
           #{priority_id}
           #{ticket_number}
           #{rts_version}
           #{status_id}
           #{enterprise}
           order by t.created_at DESC"

    return Ticket.paginate_by_sql(sql, :page => options[:page])
    
  end

  def add_user_to_notification_list

    TicketNotificationUser.create(:ticket_id => self.id, :user_id => self.user_id)

  end

  def set_enterprise

    u = User.first :conditions => {:id => self.user_id}

    unless u.nil?

      self.enterprise_id = u.enterprise_id

    end

  end

  def created_by

    unless self.created_by_id.nil? || self.created_by_id.blank?

      User.find(self.created_by_id).display_name

    else
      return "NO NAME"
    end

  end

  def self.search_options(options={})

    query = %Q[
        select o.id, tr.value
        from template_fields t, fields f, field_options o, resources r, translations tr
        where t.id   = #{options[:field]}
        and f.id           = t.field_id
        and o.field_id     = f.id
        and r.id           = o.resource_id
        and tr.resource_id = r.id
        and language_id    = #{options[:language]}
        and tr.value like "%#{options[:value]}%"
    ]

    Ticket.find_by_sql query

  end

   cattr_reader :per_page
   @@per_page = 20

end
