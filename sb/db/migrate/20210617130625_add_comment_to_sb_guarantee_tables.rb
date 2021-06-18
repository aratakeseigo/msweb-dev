class AddCommentToSbGuaranteeTables < ActiveRecord::Migration[5.2]
  def change
    change_table_comment(:sb_guarantee_customers, "SB保証先")
    change_table_comment(:sb_guarantee_exams, "SB保証審査")
    change_table_comment(:sb_guarantee_clients, "SB保証元")
  end
end
