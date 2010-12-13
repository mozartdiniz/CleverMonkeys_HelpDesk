class LogWorksController < ApplicationController

  def create

    @log_work = LogWork.new(params[:log_work])

    time_spen_without_spaces = params[:log_work]['time_spend'].gsub(/\s/, '')

    unless params[:log_work]['time_spend'].blank?

    begin

      @log_work.time_spend = Rufus.parse_time_string time_spen_without_spaces

      if @log_work.save

        respond_to do |format|

           format.js {
            render :update do |page|
                page.reload
            end

           }

        end

      end

    rescue

      respond_to do |format|

         format.js {
          render :update do |page|
              page.alert('Invalid time format')
          end
          
         }

      end
      
    end

    else

      respond_to do |format|

         format.js {
          render :update do |page|
              page.alert("Time can't be blank")
          end

         }

      end

    end

  end

end
