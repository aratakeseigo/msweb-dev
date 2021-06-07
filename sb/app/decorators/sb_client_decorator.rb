class SbClientDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def created_at
    object.created_at.strftime("%Y/%m/%d")
  end

  def sb_agent_name
    if object.sb_agent.present?
      object.sb_agent.name
    else
      "なし"
    end
  end

end
