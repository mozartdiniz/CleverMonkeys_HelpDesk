class CommentsFile < ActiveRecord::Base

  belongs_to :comment

  #paperclip upload
  has_attached_file :file,

    :path => ":rails_root/public/images/:class/:attachment/:id/:filename",


    :url => "/images/:class/:attachment/:id/:filename"

end
