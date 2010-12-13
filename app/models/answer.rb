class Answer < ActiveRecord::Base

  belongs_to :ticket
  belongs_to :template_field

  def self.save_answers(answers, ticket)

    unless answers.nil?

      answers.each do |answer|

        unless answer[1].blank?

        Answer.create(:value => answer[1],
                      :template_field_id => answer[0],
                      :ticket_id => ticket)

        end

      end

    end

  end

end
