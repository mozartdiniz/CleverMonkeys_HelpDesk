class Article < ActiveRecord::Base
  belongs_to :person
  acts_as_urlnameable :title, :mode => :multiple
  
end

class PressRelease < Article
  
end

class SpecialArticle < Article
  acts_as_urlnameable :title, :mode => :multiple, :validate => :person, :owner_association => :custom_articles
end
