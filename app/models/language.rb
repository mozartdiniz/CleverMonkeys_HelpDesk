class Language < ActiveRecord::Base    
  
  has_many :translations
  has_many :users   

end