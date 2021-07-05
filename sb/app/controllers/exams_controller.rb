class ExamsController < ApplicationController
  def list
    @q = SbGuaranteeExam.ransack(params[:q])
    @exams = @q.result(distinct: true).includes(:sb_guarantee_client, :sb_guarantee_customer, :sb_approval).page(params[:page]).decorate
  end
end
