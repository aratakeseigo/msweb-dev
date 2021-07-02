class ExamsController < ApplicationController
  def list
    @q = SbGuaranteeExam.left_joins(:sb_approval, :sb_guarantee_customer, :sb_guarantee_client).ransack(params[:q])
    @exams = @q.result(distinct: true).includes(:sb_guarantee_client, :sb_guarantee_customer, :sb_approval).page(params[:page]).decorate
  end
end
