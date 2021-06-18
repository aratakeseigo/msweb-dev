class CreateSbGuaranteeExams < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_guarantee_exams do |t|
      #sb_guarantee_exam

      t.datetime :accepted_at, null: false, comment: "受付日"
      t.bigint :sb_approval_id, comment: "決裁日"

      t.bigint :sb_client_id, null: false, comment: "SBクライアントID"

      t.bigint :sb_guarantee_client_id, null: false, comment: "SB保証元ID"
      t.bigint :sb_guarantee_customer_id, null: false, comment: "SB保証先ID"

      t.string :transaction_contents, comment: "取り扱い商品"
      t.integer :payment_method_id, comment: "決済条件"
      t.string :payment_method_optional, comment: "決済条件(補足) "

      t.boolean :new_transaction, comment: "新規取引"
      t.integer :transaction_years, comment: "取引歴"
      t.boolean :payment_delayed, comment: "遅延の有無"
      t.text :payment_delayed_memo, comment: "遅延内容"
      t.boolean :payment_method_changed, comment: "決済条件変更の有無"
      t.text :payment_method_changed_memo, comment: "変更内容"
      t.integer :other_companies_ammount, comment: "他社保証枠"
      t.string :other_guarantee_companies, comment: "他保証会社名"
      t.integer :guarantee_amount_hope, null: false, comment: "希望限度額"
      t.integer :guarantee_amount_suggested, comment: "限度額案"
      t.integer :guarantee_amount_fix, comment: "決定限度額"

      t.boolean :reinsured, comment: "再保険有無"
      t.integer :reinsurance_ammount, comment: "再保険額"
      t.boolean :gmo_reinsured, comment: "ＧＭＯ再保険有無"
      t.integer :gmo_reinsurance_ammount, comment: "ＧＭＯ再保険額"
      t.text :memo, comment: "備考"
      t.string :tsr_corporate_code, comment: "TSRコード"

      t.string :tsr_score, comment: "TSR評点"
      t.text :tsr_memo, comment: "TSR備考"
      t.string :toki_corporate_code, comment: "登記コード"

      t.text :toki_memo, comment: "登記備考"
      t.string :tdb_corporate_code, comment: "帝国コード"

      t.string :tdb_score, comment: "帝国評点"
      t.text :tdb_memo, comment: "帝国備考"
      t.string :shinko_corporate_code, comment: "信用交換所コード"

      t.string :shinko_score, comment: "信交評点"
      t.text :shinko_memo, comment: "信交備考"
      t.string :taxagency_corporate_number, comment: "法人番号"
      t.text :taxagency_memo, comment: "法人番号備考"

      t.text :bl_memo, comment: "BL備考"

      t.string :anti_social, comment: "反社"

      t.bigint :hp_type_id, comment: "ＨＰ種別"
      t.string :hp_type_optional, comment: "ＨＰ種別(補足)"
      t.string :hp_url, comment: "HPURL"
      t.text :exam_memo, comment: "特記事項"

      t.integer :other_guarantee_limits_sum, comment: "他保証"
      t.integer :risk_ammount, comment: "リスク金額合計"
      t.bigint :created_by, null: false, comment: "作成者"
      t.bigint :updated_by, null: false, comment: "更新者"
      t.timestamps
    end
  end
end
