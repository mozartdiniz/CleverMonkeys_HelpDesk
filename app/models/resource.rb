class Resource < ActiveRecord::Base

  has_many :translations

  belongs_to :field
  belongs_to :template_field
  belongs_to :field_option

end
