class TemplateField < ActiveRecord::Base

  belongs_to :template
  belongs_to :field
  belongs_to :resource

  has_many :answers

end
