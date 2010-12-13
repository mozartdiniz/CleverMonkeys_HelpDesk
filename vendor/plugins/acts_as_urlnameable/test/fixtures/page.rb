class Page < ActiveRecord::Base
  belongs_to :section
  acts_as_urlnameable :title
  
end

class BadPage < Page
  acts_as_urlnameable :title, :validate => :nobody
end

class BadderPage < Page
  belongs_to :section
  acts_as_urlnameable :title, :validate => :section
end
