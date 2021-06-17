class CreateSbGuaranteeExams < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_guarantee_exams do |t|
      #sb_guarantee_exam

      t.datetime :accepted_at, null: false, comment: "受付日"
      t.bigint :sb_approval_id, comment: "決裁日"

      t.bigint :sb_client_id, null: false, comment: "SBクライアントID"

      t.bigint :sb_guarantee_client_id, null: false, comment: "SB保証元ID"
      t.bigint :sb_guarantee_customer_id, null: false, comment: "SB保証先ID"

      t.string :shozai, comment: "取り扱い商品"
      t.string :payment_method, comment: "決済条件"

      t.boolean :new_transaction, comment: "新規取引"
      t.string :transaction_contents, comment: "取引歴（年）"
      t.boolean :payment_delayed, comment: "遅延の有無（1年以内）"
      t.string :payment_delayed_memo, comment: "遅延内容"
      t.string :payment_method_changed, comment: "決済条件変更の有無"
      t.string :payment_method_changed_memo, comment: "変更内容"

      t.integer :guarantee_limit_hope, null: false, comment: "希望限度額"
      t.integer :guarantee_limit_suggested, comment: "限度額案"
      t.integer :guarantee_limit_fix, comment: "決定限度額"

      t.boolean :reinsured, comment: "再保険有無"
      t.integer :reinsurance_ammount, comment: "再保険額（最大可能額）"
      t.boolean :gmo_reinsured, comment: "ＧＭＯ再保険有無"
      t.integer :gmo_reinsurance_ammount, comment: "ＧＭＯ再保険額（最大可能額）"
      t.string :memo, comment: "備考"
      t.string :tsr_corporate_code, comment: "TSRコード"

      t.string :tsr_score, comment: "TSR評点"
      t.string :tsr_memo, comment: "TSR備考"
      t.string :toki_corporate_code, comment: "登記"

      t.string :toki_memo, comment: "登記備考"
      t.string :tdb_corporate_code, comment: "帝国"

      t.string :tdb_score, comment: "帝国評点"
      t.string :tdb_memo, comment: "帝国備考"
      t.string :shinko_corporate_code, comment: "信用交換所"

      t.string :shinko_score, comment: "信交評点"
      t.string :shinko_memo, comment: "信交備考"
      t.string :taxagency_corporate_number, comment: "法人番号"
      t.string :taxagency_memo, comment: "法人番号備考"

      t.string :bl_memo, comment: "BL備考"

      t.string :anti_social, comment: "反社チェック"
      t.string :hp, comment: "ＨＰ種別"
      t.string :hp_url, comment: "HPURL"
      t.string :hp_memo, comment: "特記事項"
      t.boolean :zaiseki, comment: "在籍"
      t.string :gyosei_shobun, comment: "消費者庁、国土交通省等の行政処分の有無"
      t.string :gyosei_shobun_memo, comment: "処分内容"
      t.string :parent_company, comment: "グループ（親会社）"
      t.string :parent_company_bl, comment: "不芳情報"

      t.string :bs_pl, comment: "決算資料"
      t.string :parent_company_hp, comment: "親会社HP"

      t.integer :other_guarantee_limits_sum, comment: "他保証"
      t.integer :risk_ammount, comment: "リスク金額合計"
      t.bigint :created_by, null: false, comment: "作成者"
      t.bigint :updated_by, null: false, comment: "更新者"
      t.timestamps
    end
  end
end
