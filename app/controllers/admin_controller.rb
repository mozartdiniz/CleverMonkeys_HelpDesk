class AdminController < ApplicationController

  layout "login"

  def index
    redirect_to :action => "login"
  end


  def login
    
    if request.post?

      user = User.authenticate(params[:name], params[:password])
      
      if user
        session[:user_id] = user.id
        session[:user_name] = user.name
        session[:language_id] = user.language_id

        mu = GroupsRole.find(:first, :conditions => {:group_id => User.find(session[:user_id]).group_id, :role_id => Role.find_by_name("Allow to maintain users")})

        if mu.nil?
          session[:Allow_to_maintain_users] = nil
        else
          session[:Allow_to_maintain_users] = true
        end

        ml = GroupsRole.find(:first, :conditions => {:group_id => User.find(session[:user_id]).group_id, :role_id => Role.find_by_name("Allow to maintain languages")})

        if ml.nil?
          session[:Allow_to_maintain_languages] = nil
        else
          session[:Allow_to_maintain_languages] = true
        end

        mug = GroupsRole.find(:first, :conditions => {:group_id => User.find(session[:user_id]).group_id, :role_id => Role.find_by_name("Allow to maintain user groups")})

        if mug.nil?
          session[:Allow_to_maintain_user_groups] = nil
        else
          session[:Allow_to_maintain_user_groups] = true
        end

        adt = GroupsRole.find(:first, :conditions => {:group_id => User.find(session[:user_id]).group_id, :role_id => Role.find_by_name("Allow to admin tickets")})

        if adt.nil?
          session[:Allow_to_admin_tickets] = nil
        else
          session[:Allow_to_admin_tickets] = true
        end

        gett = GroupsRole.find(:first, :conditions => {:group_id => User.find(session[:user_id]).group_id, :role_id => Role.find_by_name("Allow to get tickets")})

        if gett.nil?
          session[:Allow_to_get_tickets] = nil
        else
          session[:Allow_to_get_tickets] = true
        end

        en = GroupsRole.find(:first, :conditions => {:group_id => User.find(session[:user_id]).group_id, :role_id => Role.find_by_name("Allow to admin enterprises")})

        if en.nil?
          session[:Allow_to_admin_enterprises] = nil
        else
          session[:Allow_to_admin_enterprises] = true
        end

        gc = GroupsRole.find(:first, :conditions => {:group_id => User.find(session[:user_id]).group_id, :role_id => Role.find_by_name("Allow to configure system")})

        if gc.nil?
          session[:Allow_to_configure_system] = nil
        else
          session[:Allow_to_configure_system] = true
        end


        redirect_to "/tickets"
      else
        flash.now[:notice] = "User or password is wrong!"
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:user_name] = nil
    session[:language_id] = nil

    session[:Allow_to_maintain_users] = nil
    session[:Allow_to_maintain_languages] = nil
    session[:Allow_to_maintain_modules] = nil
    session[:Allow_to_maintain_user_groups] = nil
    session[:Allow_to_edit_base_resources_languages] = nil
    session[:Allow_to_translate_resources] = nil
    session[:Allow_to_maintain_resources] = nil
    session[:Allow_to_language_pack] = nil
    session[:Allow_to_maintain_contents] = nil
    session[:Allow_to_maintain_user_resources] = nil
    session[:Allow_to_send_release_notes] = nil
    session[:Allow_to_maintain_contacts] = nil
    session[:Allow_to_admin_tickets] = nil
    session[:Allow_to_get_tickets] = nil

    flash[:notice] = "You left the system"
    redirect_to(:controller => 'admin', :action => "login")
  end

  def resetarsenha
      
      @user = User.find(2)
  
      if @user == nil
         render :text =>  "Invalid User"
      else  
        @user.password = rand(11).to_s + "" + rand(11).to_s + "" + rand(11).to_s + "" + rand(11).to_s + "" + rand(11).to_s + "" + rand(11).to_s

        ResetPassword.deliver_reset_email(@user)

        @user.save

        render :text =>  "Uma nova senha foi enviada para " + @user.email

      end

  end
  
  def acesso_negado
    
    render(:layout => 'layouts/application')
    
  end

  def forgot_password

  end

  def delivery_password

    u = User.first :conditions => {:name => params[:name]}

    unless u.nil?

      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a

      newpass = ""

      1.upto(8) { |i| newpass << chars[rand(chars.size-1)] }

      u.password = newpass

      u.save

      SendMail.deliver_password(newpass, u.name, u.email)
      
      flash[:notice] = 'A new password has been sent to your email!'

      redirect_to :action => :login

    else

      flash[:notice] = 'This user does not exist!'

      render :action => :forgot_password

    end

  end

end
