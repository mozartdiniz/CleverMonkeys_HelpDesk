module TemplateHelper

  def template_fields(render)

    template = Template.first :conditions => {:enabled => true}

    html_structure = "<table class='template_field_container'>"

    unless template.nil?

      t_fields = template.template_fields_in_order

      t_fields.each do |t_field|

        html_structure << "<tr>"

        if render == 'form'

          html_structure << template_field(t_field)

        else

          html_structure << template_value(t_field)

        end

        html_structure << "</tr>"

      end

    end

    html_structure << "</table>"

  end

  def template_field(t_field)

    if t_field.field.field_type == "text"

      field_html = template_text_field(:type => "text",
                                       :width => t_field.width,
                                       :height => t_field.height,
                                       :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value,
                                       :id     => t_field.id
                                     )
                                     
    elsif t_field.field.field_type == "search"
      field_html = template_search_field(
                                       :width => t_field.width,
                                       :height => t_field.height,
                                       :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value,
                                       :id     => t_field.id
                                     )
    elsif t_field.field.field_type == "rich_text"
      field_html = template_rich_text_field(:type => "text",
                                       :width => t_field.width,
                                       :height => t_field.height,
                                       :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value,
                                       :id     => t_field.id
                                     )
    elsif t_field.field.field_type == "select"
      field_html = template_select_field(:type => "select",
                                         :width => t_field.width,
                                         :height => t_field.height,
                                         :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value,
                                         :id     => t_field.id,
                                         :field  => t_field.field
                                     )
    elsif t_field.field.field_type == "separator"
      field_html = template_separator(
        :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value
      )
    end

    return field_html

  end

  def template_separator(options={})

    field =  "<td class='tableHeader2' colspan='2'>#{options[:label]}</td>"

  end

  def template_text_field(options={})

    field =  "<td class='template_label'><label> #{options[:label]} </label></td>"
    field << "<td class='template_field'><input type='#{options[:type]}' name='generated_field[#{options[:id]}]' style='width:#{options[:width]}; height:#{options[:height]};' class='text'/></td>"

  end

  def template_rich_text_field(options={})

    field =  "<td class='template_label' valign='top'><label> #{options[:label]} </label></td>"
    field << "<td class='template_field'>"
    field << "<textarea name='generated_field[#{options[:id]}]' style='width:#{options[:width]}; height:#{options[:height]};' class='mceEditor'></textarea>"
    field << "</td>"

  end

  def template_select_field(options={})

    field =  "<td class='template_label'><label> #{options[:label]} </label></td>"
    field << "<td class='template_field'>"
    field << "<select name='generated_field[#{options[:id]}]' style='width:#{options[:width]}; height:#{options[:height]};'>"

    options[:field].field_options.each do |option|

      field << "<option value='#{option.id}'>"
      field << "#{option.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value}"
      field << "</option>"

    end

    field << "</select>"
    field << "</td>"

  end

  def template_search_field(options={})

    field = %Q[

        <td class='template_label'><label> #{options[:label]} </label></td>
        <td>
        <input type="hidden" name='generated_field[#{options[:id]}]' id='generated_field_id_#{options[:id]}' />
        <input class="search_field"
               id="search_field_id_#{options[:id]}"
               name="search_field[#{options[:id]}]"
               style="width:#{options[:width]}"
               type="text"
               value=""
               autocomplete="off" />

        <div class="auto_complete"
             id="search_div_id_#{options[:id]}_auto_complete"
             style="position: absolute; left: 286px; top: 359px; width: 162px; display: none; "> ] + "</div>" + %Q[

        <script type="text/javascript">
        //<![CDATA[
        var di_server_version_auto_completer = new Ajax.Autocompleter('search_field_id_#{options[:id]}', 'search_div_id_#{options[:id]}_auto_complete', '/tickets/auto_complete/field/#{options[:id]}/language/#{session[:language_id]}',{
          paramName: "value",
          afterUpdateElement : send_to_hidden_#{options[:id]}
        });
      
        function send_to_hidden_#{options[:id]}(text, li) {
            $('generated_field_id_#{options[:id]}').value = li.id;
        }
        //]]>
        </script>
        </td>

    ]

  end

  def template_value(t_field)

    if t_field.field.field_type == "text"
      reponse_value = find_value(t_field, @ticket)
    elsif t_field.field.field_type == "search"
      reponse_value = find_option_value(t_field, @ticket)
    elsif t_field.field.field_type == "rich_text"
      reponse_value = find_value(t_field, @ticket)
    elsif t_field.field.field_type == "select"
      reponse_value = find_option_value(t_field, @ticket)
    elsif t_field.field.field_type == "separator"
      reponse_value = template_separator(
        :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value
      )
    end

    return reponse_value

  end


  def find_value(t_field, ticket)

    answer = t_field.answers.find(:first,
                                  :conditions => {
                                    :ticket_id => ticket.id
                                  }
    )

    label = t_field.resource.translations.find(:first, :conditions => {
        :language_id => session[:language_id]
    }).value

    unless answer.nil?
      html = template_value_html(
        :value => answer.value,
        :label => label
      )
    else
      unless ticket.assignee.blank?
        if t_field.field.field_type == "text"
          html = template_text_field(:type => "text",
                                       :width => t_field.width,
                                       :height => t_field.height,
                                       :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value,
                                       :id     => t_field.id
                                     )
        else
          html = template_rich_text_field(:type => "text",
                                         :width => t_field.width,
                                         :height => t_field.height,
                                         :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value,
                                         :id     => t_field.id
                                       )
        end
      else
        html = template_value_html(:label => label, :value => "")
      end
    end

    return html

  end

  def find_option_value(t_field, ticket)

      answer = t_field.answers.find(:first,
                                    :conditions => {
                                      :ticket_id => ticket.id
                                    }
      )

      label = t_field.resource.translations.find(:first, :conditions => {
          :language_id => session[:language_id]
      }).value

      unless answer.nil?

        field_option = FieldOption.find(answer.value.to_i)

        option_value = field_option.resource.translations.find(:first,
            :conditions => {
              :language_id => session[:language_id]
            }
        ).value

        html = template_value_html(:value => option_value, :label => label)

      else
        unless ticket.assignee.blank?
          if t_field.field.field_type == "search"
              html = template_search_field(
                                             :width => t_field.width,
                                             :height => t_field.height,
                                             :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value,
                                             :id     => t_field.id
                                           )
          else
              html = template_select_field(:type => "select",
                                           :width => t_field.width,
                                           :height => t_field.height,
                                           :label  => t_field.resource.translations.find(:first, :conditions => {:language_id => session[:language_id]}).value,
                                           :id     => t_field.id,
                                           :field  => t_field.field
                                       )
          end
        else
          html = template_value_html(:label => label, :value => "")
        end
      end
    return html
  end

  def template_value_html(options={})

    value =  "<td class='template_label' valign='top' style='padding:6px 5px 5px 10px;'>#{options[:label]} </td>"
    value << "<td>#{options[:value]} </td>"

  end

end