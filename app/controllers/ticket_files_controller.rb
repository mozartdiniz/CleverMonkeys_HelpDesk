class TicketFilesController < ApplicationController

  def create

    unless params[:ticket_file]['file'].nil?

      @ticket_file = TicketFile.new(params[:ticket_file])

      @ticket_file.save

      redirect_to :controller => :tickets, :action => :show, :id => @ticket_file.ticket_id
    else

      redirect_to :controller => :tickets, :action => :show, :id => params[:ticket_file]['ticket_id']

    end

  end

  def destroy

    @ticket_file = TicketFile.find params[:id]

    ticket_id = @ticket_file.ticket_id

    @ticket_file.destroy

    redirect_to :controller => :tickets, :action => :show, :id => ticket_id

  end

  def get_file

    @ticket_file = TicketFile.find params[:id]

    send_file(RAILS_ROOT + "/public/images/ticket_files/files/" + @ticket_file.id.to_s + "/" + @ticket_file.file_file_name, :filename => @ticket_file.file_file_name)
    
  end

end
