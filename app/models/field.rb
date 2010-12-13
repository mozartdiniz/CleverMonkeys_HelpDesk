class Field < ActiveRecord::Base

  has_many :field_options
  has_many :template_fields

  belongs_to :resource

end
