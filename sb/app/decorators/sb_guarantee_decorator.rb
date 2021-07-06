class SbGuaranteeDecorator < Draper::Decorator
  DATE_FORMAT = "%Y/%m/%d".freeze

  delegate :sb_guarantee_client, :sb_guarantee_customer

  def guarantee_start_at_formatted
    object.guarantee_start_at.strftime(DATE_FORMAT)
  end

  def guarantee_end_at_formatted
    object.guarantee_end_at.strftime(DATE_FORMAT)
  end

  def guarantee_amount_hope_delimited
    object.guarantee_amount_hope.to_s(:delimited)
  end
end
