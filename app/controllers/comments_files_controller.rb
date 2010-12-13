class CommentsFilesController < ApplicationController

  def show

    @comment_file = CommentsFile.find params[:id]

    send_file(RAILS_ROOT + "/public/images/comments_files/files/" + @comment_file.id.to_s + "/" + @comment_file.file_file_name, :filename => @comment_file.file_file_name)

  end


end
