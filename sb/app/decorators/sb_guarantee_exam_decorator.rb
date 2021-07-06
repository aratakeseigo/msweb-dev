class SbGuaranteeExamDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def guarantee_amount_hope
    object.guarantee_amount_hope&.to_s(:delimited)
  end

  def guarantee_amount_fix
    object.guarantee_amount_fix&.to_s(:delimited)
  end
  
  def sb_agent_name
    if object.sb_agent.present?
      object.sb_agent.name
    else
      "なし"
    end
  end

  decorates_association :sb_approval
  
end
