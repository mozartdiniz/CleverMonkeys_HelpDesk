class LogWork < ActiveRecord::Base

  belongs_to :ticket
  belongs_to :user

  def worked_time

    unless self.time_spend.nil? || self.time_spend.blank?

      return Rufus.to_duration_string self.time_spend

    end

  end

end
