class EnterprisesController < ApplicationController

  before_filter :countries
  before_filter :populate_lists, :only => [:ticket_defaults, :ticket_defaults_save]

  def index
    @enterprises = Enterprise.all :order => 'name'
  end

  def new

    @enterprise = Enterprise.new

  end

  def create

    @enterprise = Enterprise.new(params[:enterprise])

    if @enterprise.save
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end

  end

  def edit

    @enterprise = Enterprise.find params[:id]

  end

  def update

    @enterprise = Enterprise.find params[:id]

    @enterprise.update_attributes(params[:enterprise])

    if @enterprise.save
      redirect_to :action => :index
    else
      render :action => :edit
    end

  end

  def countries

    @countries = Country.find(:all, :order => 'name ASC').collect { |x| [x.name + " : " + x.time_zone, x.id] }

  end

  def destroy
    @country = Enterprise.find(params[:id])
    @country.destroy

    respond_to do |format|
      format.html { redirect_to :action => 'index' }
      format.xml  { head :ok }
    end
  end

  def populate_lists

    @enterprises  = Enterprise.clients.collect {|x| [x.name, x.id]}
    @status       = TicketStatus.all.collect {|x| [x.description, x.id]}
    @modules      = DiEdition.all.collect {|x| [x.description, x.id]}
    @os_versions  = OsVersion.all.collect {|x| [x.version, x.id]}
    @rts_versions = RtsVersion.all.collect {|x| [x.version, x.id]}
    @db_versions  = DatabaseVersion.all.collect {|x| [x.version, x.id]}
    @di_versions  = ReleaseNote.versions.collect {|x| [x.version, x.version]}
    @languages    = Language.all.collect {|x| [x.description, x.language_id]}
    @enterprise   = User.find(session[:user_id]).enterprise
    @priorities   = Priority.translated_priorities
    @statuses     = TicketStatus.ticket_statuses
    @ticket_type  = TicketType.translated_ticket_types
    @customers    = User.find_by_sql("select u.name, u.id from users u
                                      left outer join enterprises e
                                      on u.enterprise_id = e.id
                                      where is_your_company is null").collect {|x| [x.name, x.id]}
    @user         = User.find session[:user_id]


      #find(:all, :conditions => {:is_your_company => nil}).collect {|x| [x.name, x.id]}
  end

end
