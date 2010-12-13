class Group < ActiveRecord::Base
	has_many :user
  has_many :groups_roles
  has_many :category
  validates_presence_of :description  
end
