class CommentsController < ApplicationController

  def create

    @comment = Comment.new(params[:comment])

    @comment.user_id = session[:user_id]

    if @comment.save

      unless params[:comment_file].nil?

        params[:comment_file].each do |c|

          @comment_file = CommentsFile.new(
                                           :file => c[1],
                                           :comment_id => @comment.id
                                           )
          @comment_file.save

        end

      end
      
      @comment.send_mail

    end

    redirect_to :controller => :tickets, :action => :show, :id => @comment.ticket_id

  end

end
