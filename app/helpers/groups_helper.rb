module GroupsHelper
  
  def build_permitions_chooser(group_id)
    
    roles = Role.find(:all)
    
    group_html = ""
   
    group_html << "<table border=0 cellpadding=0 cellspacing=0 width=100%>"
    
    for r in roles 

      gr = GroupsRole.find(:first, :conditions => {:group_id => group_id, :role_id => r.id})
    
      unless gr.nil?
        c = "checked=checked"
      else  
        c = ""
      end  
    
      group_html << "<tr>"
      group_html << "<td width=1%>" + "<input type='checkbox' " + c + " name='role[" + r.id.to_s + "]'>" + "</td>"
      group_html << "<td>" + r.name + "</td>"
      group_html << "</tr>"
          
    end

    group_html << "</table>"
    
    return group_html
    
  end  
  
end
