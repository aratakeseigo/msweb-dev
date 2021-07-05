class AddExamSearchKeyToSbGuaranteeExams < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_guarantee_exams, :exam_search_key, :string, comment: "審査検索キー"
    add_index :sb_guarantee_exams, :exam_search_key
  end
end
