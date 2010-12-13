class Translation < ActiveRecord::Base
  belongs_to :resource
  belongs_to :language
end