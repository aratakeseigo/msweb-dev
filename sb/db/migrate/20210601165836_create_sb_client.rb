class CreateSbClient < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_clients, comment: "SBクライアント" do |t|
      t.integer :entity_id, null: false, comment: "法人ID"
      t.string :name, null: false, comment: "クライアント名"
      t.integer :status_id, comment: "ステータスID"
      t.string :taxagency_corporate_number , comment: "法人番号"
      t.integer :area_id, comment: "エリアID"
      t.integer :sb_user_id, comment: "SB担当者ID"
      t.string :daihyo_name, null: false, comment: "代表者名"
      t.string :zip_code, comment: "郵便番号"
      t.integer :prefecture_code, comment: "都道府県コード"
      t.string :address , comment: "住所"
      t.string :tel, comment: "電話番号"
      t.string :industry_code1, comment: "業種コード1"
      t.string :industry_code2, comment: "業種コード2"
      t.string :established, comment: "設立年月"
      t.integer :annual_sales, comment: "年商（千円）"
      t.integer :channel_id, comment: "媒体ID"
      t.references :sb_agent, foreign_key: true, comment: "SB代理店ID"
      t.boolean :anti_social_flag, default: false, comment: "反社チェックフラグ"
      t.text :content, comment: "内容"
      t.timestamps
    end
  end
end
