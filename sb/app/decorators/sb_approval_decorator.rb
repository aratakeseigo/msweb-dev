class SbApprovalDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def applied_at
    object.applied_at.strftime("%Y/%m/%d %H:%M")
  end

  def approved_at
    object.approved_at.strftime("%Y/%m/%d %H:%M")
  end

end
