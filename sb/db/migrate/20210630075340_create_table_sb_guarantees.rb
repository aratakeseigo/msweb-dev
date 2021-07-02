class CreateTableSbGuarantees < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_guarantees, comment: "SB保証" do |t|
      #sb_guarantees
      t.datetime :accepted_at, null: false, comment: "受付日"
      t.string :exam_search_key, null: false, comment: "審査検索キー"
      t.string :company_name, null: false, comment: "法人名"
      t.string :daihyo_name, null: false, comment: "代表者名"
      t.datetime :guarantee_start_at, null: false, comment: "保証開始日"
      t.datetime :guarantee_end_at, null: false, comment: "保証終了日"
      t.bigint :guarantee_amount_hope, null: false, comment: "保証依頼額"
      t.bigint :guarantee_amount, null: false, comment: "保証額"
      t.bigint :sb_guarantee_exam_id, null: false, comment: "保証審査ID"
      t.bigint :sb_client_id, null: false, comment: "クライアントID"
      t.bigint :sb_guarantee_client_id, null: false, comment: "保証元ID"
      t.bigint :sb_guarantee_customer_id, null: false, comment: "保証先ID"
      t.integer :status_id, null: false, comment: "ステータスID"
      t.bigint :sb_guarantee_request_id, null: false, comment: "保証依頼ID"
      t.bigint :sb_approval_id, comment: "決裁ID"
      t.bigint :created_by, null: false, comment: "作成者ID"
      t.bigint :updated_by, null: false, comment: "更新者ID"
      t.timestamps
    end
  end
end
