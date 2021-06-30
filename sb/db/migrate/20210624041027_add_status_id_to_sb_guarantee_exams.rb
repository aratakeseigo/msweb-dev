class AddStatusIdToSbGuaranteeExams < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_guarantee_exams, :status_id, :integer, comment: "ステータスID"
  end
end
