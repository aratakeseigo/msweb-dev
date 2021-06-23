class AddColumnSbGuaranteeExamRequestIdToSbGuaranteeExams < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_guarantee_exams, :sb_guarantee_exam_request_id, :bigint, comment: "保証審査依頼ID"
  end
end
