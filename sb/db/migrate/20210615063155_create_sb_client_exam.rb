class CreateSbClientExam < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_client_exams do |t|
      t.references :sb_client, foreign_key: true, comment: "SBクライアントID"
      t.integer :examination_result, comment: "審査結果"
      t.text :reject_reason, comment: "否決理由"
      t.boolean :anti_social, default: false, comment: "反社(反社の場合true)"
      t.text :anti_social_memo, comment: "反社メモ"
      t.string :tsr_score, comment: "TSR点数"
      t.string :tdb_score, comment: "帝国点数"
      t.text :communicate_memo, comment: "社内連絡メモ"
      t.integer :created_by, null: false, comment: "作成者"
      t.integer :updated_by, null: false, comment: "更新者"
      t.timestamps
    end
  end
end
