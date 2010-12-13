class TicketsController < ApplicationController

  before_filter :populate_lists, :only => [:index, :new, :create, :show, :update, :ticket_created, :print, :ticket_default_values]
  before_filter :language, :only => [:new, :create, :show, :ticket_created ]
  before_filter :find_user_in_session, :only => [:index, :new, :new_log_work, :new_log_work_home, :show]
  before_filter :find_ticket_by_params, :only => [:update, :show, :get_ticket]

  uses_tiny_mce

  def index

    @enterprise = Enterprise.find @user.enterprise_id unless @user.enterprise_id.nil?

    unless @enterprise.nil?      
      unless @enterprise.is_your_company
        
        open_tickets
        working_tickets
        closed_tickets

        render :partial => 'client_ticket', :layout => "application"
      else

        @priorities   = Priority.all.collect {|x| [x.description, x.id]}
        your_company  = Enterprise.first :conditions => {
                                              :is_your_company => true
                                              }

        @users        = User.find(:all,
                                  :conditions => {:enterprise_id => your_company}).collect { |x| [x.display_name.nil? ? x.name : x.display_name, x.id]  }

        open_tickets
        working_tickets
        closed_tickets

        respond_to do |format|
          format.html {
            render :partial => 'staff_ticket', :layout => "application"
          }
          format.js {
           render :action => :index
          }
        end

      end      

    end    

  end

  def enterprise
    unless @enterprise.nil?
      unless @enterprise.is_your_company
        @enterprise_id = @enterprise.id
      else
        @enterprise_id = params[:filter].nil? ? "" : params[:filter]['enterprise_id']
      end
    end
  end

  def open_tickets
    
    enterprise

    @open_tickets = Ticket.filter(
                            :assigned_user_id => params[:filter].nil? ? "" : params[:filter]['assigned_user_id'],
                            :di_version       => params[:filter].nil? ? "" : params[:filter]['di_version'],
                            :priority_id      => params[:filter].nil? ? "" : params[:filter]['priority_id'],
                            :ticket_number    => params[:filter].nil? ? "" : params[:filter]['ticket_number'],
                            :rts_version      => params[:filter].nil? ? "" : params[:filter]['rts_version'],
                            :subject          => params[:filter].nil? ? "" : params[:filter]['subject'],
                            :status_id        => 'open',
                            :enterprise_id    => @enterprise_id,
                            :page             => params[:page].nil? ? 1 : params[:page]
                             )
  end

  def working_tickets

    enterprise

    @working_tickets = Ticket.filter(
                            :assigned_user_id => params[:filter].nil? ? "" : params[:filter]['assigned_user_id'],
                            :di_version       => params[:filter].nil? ? "" : params[:filter]['di_version'],
                            :priority_id      => params[:filter].nil? ? "" : params[:filter]['priority_id'],
                            :ticket_number    => params[:filter].nil? ? "" : params[:filter]['ticket_number'],
                            :rts_version      => params[:filter].nil? ? "" : params[:filter]['rts_version'],
                            :subject          => params[:filter].nil? ? "" : params[:filter]['subject'],
                            :status_id        => 'working',
                            :enterprise_id    => @enterprise_id,
                            :page             => params[:page].nil? ? 1 : params[:page]
                             )
  end

  def closed_tickets

    enterprise

    @closed_tickets = Ticket.filter(
                            :assigned_user_id => params[:filter].nil? ? "" : params[:filter]['assigned_user_id'],
                            :di_version       => params[:filter].nil? ? "" : params[:filter]['di_version'],
                            :priority_id      => params[:filter].nil? ? "" : params[:filter]['priority_id'],
                            :ticket_number    => params[:filter].nil? ? "" : params[:filter]['ticket_number'],
                            :rts_version      => params[:filter].nil? ? "" : params[:filter]['rts_version'],
                            :subject          => params[:filter].nil? ? "" : params[:filter]['subject'],
                            :status_id        => 'closed',
                            :enterprise_id    => @enterprise_id,
                            :page             => params[:page].nil? ? 1 : params[:page]
                             )
  end

  def new
    
    @ticket = Ticket.new

    @enterprise = Enterprise.find @user.enterprise_id

    if @enterprise.is_your_company

      customer = User.first :conditions => {:enterprise_id => @first_enterprise.id}

      unless customer.enterprise_id.nil?

        @tickets_default = TicketsDefault.find_by_enterprise_id customer.enterprise_id

        if @tickets_default.nil?
          @tickets_default = TicketsDefault.new
        else
          set_ticket_defaults
        end

      end

    else

        @tickets_default = TicketsDefault.find_by_enterprise_id @enterprise.id

        if @tickets_default.nil?
          @tickets_default = TicketsDefault.new
        else
          set_ticket_defaults
        end
      
    end

  end

  def create

    @ticket = Ticket.new(params[:ticket])

    if @ticket.save

      Answer.save_answers(params[:generated_field], @ticket.id)

      unless params[:comment_file].nil?

        params[:comment_file].each do |f|

          ticket_file = TicketFile.new(
                                       :ticket_id => @ticket.id,
                                       :file => f[1]
                                     )

          ticket_file.save

        end

      end

#      if @ticket.user.enterprise.is_your_company.nil? || @ticket.user.enterprise.is_your_company == false
#
#        SendMail.deliver_ticket_copy(@ticket.id)
#
#      end

      redirect_to :action => :show, :id => @ticket.id
    else
      render :action => :new
    end

  end

  def update

    @ticket.update_attributes(params[:ticket])

    @ticket_file   = TicketFile.new
    @files         = @ticket.ticket_files

    if @ticket.save

      Answer.save_answers(params[:generated_field], @ticket.id)

      redirect_to :action => :show, :id => @ticket.id
    else
      render :action => :show
    end

  end

  def list_of_new_tickets
  end

  def show
    @ticket_file   = TicketFile.new
    @comment       = Comment.new
    @comments      = @ticket.comments
    @files         = @ticket.ticket_files
    @comment_file  = CommentsFile.new
    @log_work      = @ticket.log_works
  end

  def print

    show

    @print = true

    render :action => :show, :layout => 'print_ticket'

  end

  def populate_lists

    @enterprises  = Enterprise.find(:all, :order => 'name ASC').collect {|x| [x.name, x.id]}
    @status       = TicketStatus.find(:all, :order => 'description ASC').collect {|x| [x.description, x.id]}
    @languages    = Language.all.collect {|x| [x.description, x.id]}
    @enterprise   = User.find(session[:user_id]).enterprise
    @priorities   = Priority.all.collect {|x| [x.description, x.id]}
    @statuses     = TicketStatus.all.collect {|x| [x.description, x.id]}
    @ticket_type  = TicketType.all.collect {|x| [x.description, x.id]}
    @first_enterprise    = Enterprise.find(:first, :order => "name ASC")
    @user         = User.find session[:user_id]

  end

  def language
    if params[:language].nil?

      @language = User.find(session[:user_id]).language_id

      if @language.nil?
        @language = 'en'
      end

    else
      @language = params[:language]
    end
  end

  def set_priorities

    tickets = params[:ticket_ids].split(',')

    tickets.each do |t|

      tk = Ticket.find(t)
      tk.priority_id = params[:value]
      tk.save

    end

  end

  def set_users

    tickets = params[:ticket_ids].split(',')

    tickets.each do |t|

      tk = Ticket.find(t)
      tk.assigned_user_id = params[:value]
      tk.save

    end

  end

  def get_ticket

    @ticket.assigned_user_id = session[:user_id]

    @ticket.save

    TicketNotificationUser.create(:user_id => session[:user_id], :ticket_id => params[:id])

    redirect_to :action => "show", :id => @ticket.id

  end

  def auto_complete

    @options = Ticket.search_options(
      :field => params[:field],
      :language => params[:language],
      :value => params[:value]
    )

    render :partial => "auto_complete", :layout => false

  end

  def new_comment

    @comment = Comment.new

    @ticket  = Ticket.find params[:ticket_id]

    render :partial => 'comment_form'

  end

  def clear_comment

    render :nothing => true

  end

  def new_log_work

    @ticket  = Ticket.find params[:ticket_id]

    @log_work = LogWork.new

    render :partial => 'log_work_form'

  end

  def new_log_work_home

    @ticket  = Ticket.find params[:ticket_id]

    @log_work = LogWork.new

    render :partial => 'log_work_form_home'

  end

  def clear_log_work

    render :nothing => true

  end

  def find_user_in_session
    @user = User.find session[:user_id]
  end

  def find_ticket_by_params
    @ticket = Ticket.find params[:id]
  end

  def ticket_default_values

    @ticket = Ticket.new

    customer = User.find params[:ticket]["user_id"]

    unless customer.enterprise_id.nil?

      @tickets_default = TicketsDefault.find_by_enterprise_id customer.enterprise_id

      if @tickets_default.nil?
        @tickets_default = TicketsDefault.new
      else
        set_ticket_defaults
      end

    end

    render :partial => 'ticket_defaults'

  end

  def set_ticket_defaults
      @ticket.di_version        = @tickets_default.di_version
      @ticket.device_version    = @tickets_default.device_version
      @ticket.rts_versions_id   = @tickets_default.rts_versions_id
      @ticket.rts_database_info = @tickets_default.rts_database_info
      @ticket.di_os_version     = @tickets_default.di_os_version
      @ticket.di_database_info  = @tickets_default.di_database_info
      @ticket.language_id       = @tickets_default.language_id
  end

end