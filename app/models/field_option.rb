class FieldOption < ActiveRecord::Base

  belongs_to :field
  belongs_to :resource

end