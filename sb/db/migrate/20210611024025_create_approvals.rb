class CreateApprovals < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_approvals do |t|
      t.integer :status_id, default: 0, comment: "結果id(申請中:0 差し戻し:9 承認:1)"
      t.integer :applied_by, comment: "申請者"
      t.datetime :applied_at, comment: "申請日時"
      t.string :apply_comment, comment: "申請時コメント"
      t.integer :approved_by, comment: "決裁者"
      t.datetime :approved_at, comment: "申請日時"
      t.string :approve_comment, comment: "決裁時コメント"
      t.integer :created_by, null: false, comment: "作成者"
      t.integer :updated_by, null: false, comment: "更新者"
      t.string :type, comment: "決裁対象Model(STI)"
      t.integer :relation_id, comment: "決裁対象ID(STI)"

      t.timestamps null: false
    end
  end
end
