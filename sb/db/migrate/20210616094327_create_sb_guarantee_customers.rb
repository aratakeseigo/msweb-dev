class CreateSbGuaranteeCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_guarantee_customers do |t|
      t.integer :sb_client_id, null: false, comment: "SBクライアントID"

      t.integer :sb_guarantee_client_id, null: false, comment: "SB保証元ID"

      t.string :company_name, null: false, comment: "法人名"
      t.integer :entity_id, comment: "法人ID"

      t.string :address, comment: "住所"

      t.string :tel, comment: "電話"
      t.string :daihyo_name, comment: "代表者名"

      t.string :stock_securities_code, comment: "証券番号"
      t.string :stock_market, comment: "市場"

      t.integer :created_by, null: false, comment: "作成者"
      t.integer :updated_by, null: false, comment: "更新者"
      t.timestamps
    end
  end
end
