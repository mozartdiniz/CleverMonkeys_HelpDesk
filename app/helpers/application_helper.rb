# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def filter_observe_fields(options)

    html = ""

    options[:fields].each do |f|

      html << (observe_field options[:prefix] + '_' + f, 
                :url => { :controller => options[:controller], :action => options[:action] },
                :method => :get,
                :frequency => 0.50,
                :before => "$('loading_spin').show();",
                :complete => "$('loading_spin').hide();",
                :with => filter_params_to_ajax(options[:prefix], options[:fields]))
    end

    return html

  end

  def filter_params_to_ajax(prefix, options)

      parameters = ""

      options.each do |o|
        if o == options[0]
          parameters << "'" + prefix + "[" + o + "]=' + $('" + prefix + "_" + o + "').value"
        else
          parameters << " + '&" + prefix + "[" + o + "]=' + $('" + prefix + "_" + o + "').value"
        end
      end

    return parameters

  end

  def system_title
    GlobalConfiguration.find_by_key("system_title").value
  end

  def system_footer
    GlobalConfiguration.find_by_key("system_footer").value
  end

end
