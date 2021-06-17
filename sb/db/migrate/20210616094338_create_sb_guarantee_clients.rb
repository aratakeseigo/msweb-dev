class CreateSbGuaranteeClients < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_guarantee_clients do |t|
      #sb_guarantee_client

      t.bigint :sb_client_id, null: false, comment: "SBクライアントID"

      t.string :company_name, null: false, comment: "保証元法人名"
      t.string :address, comment: "保証元住所"
      t.string :tel, comment: "保証元電話"
      t.string :daihyo_name, comment: "保証元代表者名"
      t.string :taxagency_corporate_number, comment: "保証元法人番号"

      t.bigint :entity_id, comment: "法人ID"

      t.bigint :created_by, null: false, comment: "作成者"
      t.bigint :updated_by, null: false, comment: "更新者"
      t.timestamps
    end
  end
end
