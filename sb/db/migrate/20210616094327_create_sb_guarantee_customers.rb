class CreateSbGuaranteeCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_guarantee_customers do |t|
      #sb_guarantee_custromer

      t.bigint :sb_guarantee_client_id, null: false, comment: "SB保証元ID"

      t.string :company_name, null: false, comment: "法人名"
      t.bigint :entity_id, comment: "法人ID"

      t.string :address, comment: "住所"

      t.string :tel, comment: "電話"
      t.string :daihyo_name, comment: "代表者名"

      t.string :stock_securities_code, comment: "証券番号"
      t.string :stock_market, comment: "市場"

      t.bigint :created_by, null: false, comment: "作成者"
      t.bigint :updated_by, null: false, comment: "更新者"
      t.timestamps
    end
  end
end
