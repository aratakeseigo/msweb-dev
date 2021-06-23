class CreateTableSbGuaranteeExamRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_guarantee_exam_requests, comment: "保証審査依頼" do |t|
      t.bigint :sb_client_id, null: false, comment: "SBクライアントID"
      t.bigint :created_by, null: false, comment: "作成者"
      t.bigint :updated_by, null: false, comment: "更新者"
      t.timestamps
    end
  end
end
