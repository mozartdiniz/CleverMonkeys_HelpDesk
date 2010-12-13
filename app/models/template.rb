class Template < ActiveRecord::Base

  has_many :template_fields
  has_many :tickets

  def template_fields_in_order

    TemplateField.all :conditions => {:template_id => self.id}, :order => "field_order ASC"

  end

end
