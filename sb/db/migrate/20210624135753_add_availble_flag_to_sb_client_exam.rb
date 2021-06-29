class AddAvailbleFlagToSbClientExam < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_client_exams, :available_flag, :boolean, default: false, null: false, after: :communicate_memo, comment: "有効フラグ"
  end
end
