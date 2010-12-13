class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  
  before_filter :groups, :enterprises, :languages, :only => [:new, :create, :edit, :update]
  
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    
    @user_languages = UserLanguages.languages_by_user(@user.id)
    
    languages(@user.id.to_s)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to :action => "index"}
        format.xml  { render :xml => @user,
                             :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      
      if @user.update_attributes(params[:user])

        unless params[:delete_image].nil?
          @user.photo = nil
        end

        @user.save

        flash[:notice] = 'User was successfully updated.'
        format.html {

          unless params[:edit_profile].nil?
            redirect_to '/'
          else
            redirect_to :action => "index"
          end

        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
    
  def add_language

    @user = User.find params[:user_id]
    
    UserLanguages.create(:user_id => params[:user_id],
                         :language_id => params[:language]["language_id"],
                         :created_at => Time.now,
                         :updated_at => Time.now)
    
    @user_languages = UserLanguages.languages_by_user(params[:user_id])

    languages(params[:user_id])

    respond_to do |format|
      format.js
    end
    
    #render :partial => "user_languages", :object => @user_languages
    
  end  
  
  def destroy_language

    @user = User.find params[:user_id]
    
    ul = UserLanguages.find(:first, 
                            :conditions => {:user_id => params[:user_id],
                                            :language_id => params[:language_id]})

    if @user.language_id == params[:language_id]
      @user.language_id = nil
    end

    @user.save

    ul.destroy

    languages(params[:user_id])
    
    @user_languages = UserLanguages.languages_by_user(params[:user_id])
    
    respond_to do |format|
      format.js
    end
    
  end 
  
  def groups
    
    @groups = Group.find(:all).collect {|x| [x.description, x.id]}
    
  end

  def enterprises

    @enterprises = Enterprise.find(:all, :order => 'name ASC').collect {|x| [x.name, x.id]}

  end

  def languages    

    @languages = Language.find(:all, :order => 'description ASC').collect {|x| [x.description, x.id]}
    
  end

  def edit_profile

    @user = User.find params[:id]

    if params[:id].to_i != session[:user_id].to_i

      redirect_to :controller => 'admin', :action => 'acesso_negado'

    end

  end

  def default_language

    @user = User.find params[:id]

    @user.language_id = params[:language_id]

    @user.save

    languages(@user.id.to_s)

    @user_languages = UserLanguages.languages_by_user(@user.id)

    respond_to do |format|
      format.js
    end

  end

  
end
