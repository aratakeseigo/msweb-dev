class ExamsController < ApplicationController
  def index
    # 初期検索値設定（ステータス：審査待ち、決裁待ち）
    redirect_to action: 'list', q: {"status_id_eq_any" => [Status::ExamStatus::READY_FOR_EXAM,Status::ExamStatus::READY_FOR_APPROVAL]}
  end

  def list
    @q = SbGuaranteeExam.ransack(params[:q])
    @exams = @q.result(distinct: true).includes(:sb_guarantee_client, :sb_guarantee_customer, :sb_approval).page(params[:page]).decorate
  end
end
