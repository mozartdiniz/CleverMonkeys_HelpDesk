# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :authorize,
                :check_authorization,
                :set_language,
                :set_time_zone,
                :except => [[:login],[:resetarsenha],[:acesso_negado],[:logout],[:forgot_password],[:delivery_password]]

  #before_filter :authorize, :set_language, :set_time_zone, :except => [[:login],[:resetarsenha],[:acesso_negado],[:logout],[:get_resources_since],[:download_resources_since], [:get_development_resources_since], [:forgot_password], [:delivery_password], [:release_notes], [:release_note]]
  
  helper :all          
  protect_from_forgery 
  
  protected
  def authorize

    u = User.find_by_id(session[:user_id])

    if u.nil?
      flash[:notice] = "Please, log in first."
      redirect_to :controller => 'admin', :action => 'login'
    end
  end  
  
  def check_authorization
      
      permission = ActiveRecord::Base.connection.select_all "SELECT * FROM users u, groups_roles g, roles r, rights_roles rr, rights ri where u.id = " + session[:user_id].to_s + "  and g.group_id = u.group_id and r.id = g.role_id and rr.role_id = r.id and rr.right_id = ri.id and ri.controller = '" + params[:controller] + "' and ri.action = '" + params[:action] + "'"

      if permission.size == 0

        redirect_to :controller => 'admin', :action => 'acesso_negado', :c => params[:controller], :a => params[:action]

        return false
      
      else        
        return true
      end
      
  end

  def set_time_zone

    user = User.find_by_id(session[:user_id])

    unless user.nil?

      unless user.enterprise.country.nil?

        Time.zone = user.enterprise.country.name

      end

    end

  end

  def set_language

      unless session[:language_id].nil?

        user = User.find_by_id(session[:user_id])

        unless user.nil?

          session[:language_id]  = user.language_id

          I18n.locale = Language.find(session[:language_id]).iso

        end

      end

  end


  
end
