class GlobalConfigurationsController < ApplicationController
  
  def index

    @system_title     = GlobalConfiguration.find_by_key 'system_title'
    @system_footer    = GlobalConfiguration.find_by_key 'system_footer'
    @system_dev_host  = GlobalConfiguration.find_by_key 'system_dev_host'
    @system_pro_host  = GlobalConfiguration.find_by_key 'system_pro_host'
    @dev_host         = GlobalConfiguration.find_by_key 'dev_host'
    @dev_port         = GlobalConfiguration.find_by_key 'dev_port'
    @dev_email        = GlobalConfiguration.find_by_key 'dev_email'
    @dev_pass         = GlobalConfiguration.find_by_key 'dev_pass'
    @pro_host         = GlobalConfiguration.find_by_key 'pro_host'
    @pro_port         = GlobalConfiguration.find_by_key 'pro_port'
    @pro_email        = GlobalConfiguration.find_by_key 'pro_email'
    @pro_pass         = GlobalConfiguration.find_by_key 'pro_pass'

  end

  def update

    @system_title  = GlobalConfiguration.find_by_key 'system_title'
    @system_footer = GlobalConfiguration.find_by_key 'system_footer'
    @system_dev_host  = GlobalConfiguration.find_by_key 'system_dev_host'
    @system_pro_host  = GlobalConfiguration.find_by_key 'system_pro_host'
    @dev_host      = GlobalConfiguration.find_by_key 'dev_host'
    @dev_port      = GlobalConfiguration.find_by_key 'dev_port'
    @dev_email     = GlobalConfiguration.find_by_key 'dev_email'
    @dev_pass      = GlobalConfiguration.find_by_key 'dev_pass'
    @pro_host      = GlobalConfiguration.find_by_key 'pro_host'
    @pro_port      = GlobalConfiguration.find_by_key 'pro_port'
    @pro_email     = GlobalConfiguration.find_by_key 'pro_email'
    @pro_pass      = GlobalConfiguration.find_by_key 'pro_pass'

    @system_title.update_attribute(:value, params[:system_title])
    @system_footer.update_attribute(:value, params[:system_footer])
    @system_dev_host.update_attribute(:value, params[:system_dev_host])
    @system_pro_host.update_attribute(:value, params[:system_pro_host])
    @dev_host.update_attribute(:value, params[:dev_host])
    @dev_port.update_attribute(:value, params[:dev_port])
    @dev_email.update_attribute(:value, params[:dev_email])
    @dev_pass.update_attribute(:value, params[:dev_pass])
    @pro_host.update_attribute(:value, params[:pro_host])
    @pro_port.update_attribute(:value, params[:pro_port])
    @pro_email.update_attribute(:value, params[:pro_email])
    @pro_pass.update_attribute(:value, params[:pro_pass])

    flash[:notice] = "Global configurations successfully updated!"

    redirect_to :action => :index

  end

end
