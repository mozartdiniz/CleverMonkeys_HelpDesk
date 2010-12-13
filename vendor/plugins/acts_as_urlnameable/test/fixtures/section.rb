class Section < ActiveRecord::Base
  has_many :pages
  acts_as_urlnameable :name, :overwrite => true
  
end