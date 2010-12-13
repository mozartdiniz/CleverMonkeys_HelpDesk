class Role < ActiveRecord::Base
  has_many :groups_roles
  has_many :rights_role
end
