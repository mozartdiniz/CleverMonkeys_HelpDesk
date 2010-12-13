class Person < ActiveRecord::Base
  has_many :articles, :dependent => :destroy
  has_many :custom_articles, :class_name => 'SpecialArticle', :dependent => :destroy
  acts_as_urlnameable :full_name
  
end

class PersonWithCustomValidation < Person
  
  protected 
  def validate_urlname
    errors.add(:urlname, "is invalid. You've got it all wrong! I'm not a name, I AM a number!")
  end
end

class Writer < Person
  acts_as_urlnameable :full_name
  
  protected
  
  alias_method :old_urlnameify, :urlnameify
  def urlnameify(text)
    'writer_' + old_urlnameify(text)
  end
  
end
