# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_04_002726) do

  create_table "ab_alarm_mail_settings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アラームメール受信設定テーブル", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "ユーザーID"
    t.boolean "alarm_level1_flag", default: true, null: false, comment: "チェックアラーム受信設定"
    t.boolean "alarm_level2_flag", default: true, null: false, comment: "注意アラーム受信設定"
    t.boolean "alarm_level3_flag", default: true, null: false, comment: "要警戒アラーム受信設定"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["user_id"], name: "user_id", unique: true
  end

  create_table "ab_alarm_monthly_totals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "マスター毎の月次アラーム数合計", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスターID"
    t.integer "alarm_level_1", comment: "アラームレベル1合計"
    t.integer "alarm_level_2", comment: "アラームレベル2合計"
    t.integer "alarm_level_3", comment: "アラームレベル3合計"
    t.date "target_month", comment: "対象月"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id", "target_month"], name: "cmid_tm_index", unique: true
  end

  create_table "ab_alarm_totals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "半期ごとの取引先別アラーム数合計", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先ID"
    t.integer "alarm_level_1", comment: "アラームレベル1合計"
    t.integer "alarm_level_2", comment: "アラームレベル2合計"
    t.integer "alarm_level_3", comment: "アラームレベル3合計"
    t.date "start_month", comment: "開始月"
    t.date "end_month", comment: "終了月"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id", "start_month"], name: "cmid_sd_index", unique: true
  end

  create_table "ab_annual_payment_investigate_limits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "AB年払い会員過去調査期日確認テーブル", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "メンバーID"
    t.datetime "alarm_investigate_limit", null: false, comment: "過去調査有効期限"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "member_id", unique: true
  end

  create_table "ab_credit_mail_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "信用状況更新通知のためのメール送信リスト", force: :cascade do |t|
    t.integer "before_credit_id", null: false, comment: "更新前の信用状況ID"
    t.integer "after_credit_id", null: false, comment: "更新後の信用状況ID"
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "customer_master_id", null: false, comment: "取引先マスターID"
    t.boolean "send_flag", default: false, null: false, comment: "送信フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["after_credit_id"], name: "FK_ACML_ACID"
    t.index ["before_credit_id"], name: "FK_ACML_BCID"
    t.index ["customer_master_id"], name: "FK_ACML_CMID"
    t.index ["member_id"], name: "FK_ACML_MID"
  end

  create_table "ab_customer_memo_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "メモ履歴情報", force: :cascade do |t|
    t.integer "customer_id", null: false, comment: "取引先ID"
    t.string "member_memo", limit: 400, null: false, comment: "メモ"
    t.datetime "member_memo_at", null: false, comment: "メモされた日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_id"], name: "customer_id"
  end

  create_table "ab_selectbox_value_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "セレクトボックス値", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "ユーザーID"
    t.integer "period_in_top", comment: "トップ画面の期間"
    t.integer "number_in_top", comment: "トップ画面の表示件数"
    t.integer "number_in_alarms", comment: "アラーム一覧画面の表示件数"
    t.integer "number_in_customers", comment: "取引先一覧画面の表示件数"
    t.integer "number_in_myal_detail", comment: "取引先詳細画面の表示件数"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["user_id"], name: "user_id"
  end

  create_table "accounting_kanpou_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "会計情報（官報）数値", force: :cascade do |t|
    t.integer "accounting_kanpou_root_id", null: false, comment: "官報主要ID"
    t.string "item", comment: "勘定科目"
    t.bigint "value", comment: "値"
    t.string "display_code", limit: 2, comment: "表示コード"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["accounting_kanpou_root_id"], name: "FK_AKI_ROOT"
  end

  create_table "accounting_kanpou_roots", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "会計情報（官報）主要", force: :cascade do |t|
    t.integer "entity_id", comment: "エンティティID"
    t.string "company_name", limit: 200, comment: "会社名"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.string "address", comment: "住所"
    t.string "daihyo_name", comment: "代表者名"
    t.string "url", comment: "URL"
    t.string "currency_code", limit: 3, comment: "通貨"
    t.date "disclosed_date", null: false, comment: "開示日"
    t.date "as_of_date", null: false, comment: "基準日"
    t.string "specific_status", limit: 1, null: false, comment: "特定状態"
    t.text "memo", comment: "メモ"
    t.date "acquired_date", null: false, comment: "取得日"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "FK_AKR_ENTITY"
  end

  create_table "accs_bl_infos", primary_key: "bi_serial_number", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アクセスＢＬ情報", force: :cascade do |t|
    t.string "corporate_code", limit: 11, comment: "企業コード"
    t.string "bl_out_date", comment: "BL出力日"
    t.string "bl_out_date_japan", comment: "BL出力日_日本"
    t.string "bl_out_number", comment: "BL出力番号"
    t.string "bl_company_name", comment: "企業名"
    t.string "bl_company_adrress", comment: "住所"
    t.string "bl_boss_name", comment: "代表者"
    t.string "bl_business_category", comment: "業種"
    t.string "bl_research_agency"
    t.string "bl_info_media"
    t.string "bl_mark", comment: "BLマーク"
    t.string "bl_mark_text"
    t.string "bl_alarm_lebel"
    t.string "bl_alarm_category"
    t.string "taxagency_corporate_number", limit: 13, comment: "法人番号"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["corporate_code"], name: "IDX_ACCS_BL"
  end

  create_table "accs_clients", primary_key: "client_code", id: :string, limit: 11, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アクセスクライアント情報", force: :cascade do |t|
    t.string "client_name", comment: "クライアント名"
    t.string "spread_sheet_id", limit: 80, comment: "スプレッドシートID"
    t.string "client_entry_date", comment: "クライアント登録日"
    t.string "client_agreement_date", comment: "クライアント契約日"
    t.string "corporate_code", limit: 11, comment: "企業コード"
    t.string "agency_code", comment: "代理店コード"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["client_code"], name: "IDX_ACCS_CL"
  end

  create_table "accs_hosho_masters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アクセス保証開始情報", force: :cascade do |t|
    t.string "hosho_no", null: false, comment: "保証開始NO"
    t.string "kyoten", comment: "拠点"
    t.string "client_name", comment: "クライアント名"
    t.string "client_no", comment: "Client_NO"
    t.string "hsk_name", comment: "保証先名"
    t.string "customer_no", comment: "Customer_NO"
    t.string "sinsa_kekka_no", comment: "審査結果一連番号"
    t.string "hosho_kaisi_bi", comment: "保証開始日"
    t.string "hosho_shuryo_bi", comment: "保証終了日"
    t.integer "saiken_gaku", comment: "保証債権額"
    t.float "hosho_rate", comment: "保証料率（月）"
    t.string "hosho_term", comment: "保証期間"
    t.integer "hosho_ryo", comment: "保証料（円）"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_no"], name: "IDX_ACCS_HOSHO_KG"
    t.index ["hosho_no"], name: "IDX_ACCS_HOSHO"
  end

  create_table "accs_imp_mngs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アクセス情報取込管理", force: :cascade do |t|
    t.datetime "imp_date", null: false, comment: "取込日時"
    t.integer "ins_count", null: false, comment: "登録件数"
    t.integer "upd_count", null: false, comment: "更新件数"
  end

  create_table "accs_sinsa_kekkas", primary_key: "ID", id: :integer, default: nil, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アクセス審査結果", force: :cascade do |t|
    t.string "ukebi", comment: "受け日"
    t.string "kessaibi", comment: "決済日"
    t.string "shinsa_code", comment: "審査コード"
    t.string "client_code", limit: 11, comment: "クライアントコード"
    t.string "client_name", comment: "クライアント名"
    t.string "company_name", comment: "企業名"
    t.string "corporate_code", limit: 11, comment: "企業コード"
    t.string "corporate_yago"
    t.string "old_company_name"
    t.string "corporate_address_all", comment: "企業全住所"
    t.string "address_text", comment: "-"
    t.string "corporate_phone_number", comment: "電話番号"
    t.string "boss_name", comment: "代表者"
    t.string "shozai", comment: "商材"
    t.string "state_payment_method", comment: "支払方法"
    t.string "field16"
    t.string "field17"
    t.string "saiken_type", comment: "債権種別"
    t.string "state_bill_sight", comment: "支払サイト"
    t.string "field20", comment: "-"
    t.string "state_transaction_years", comment: "取引年数"
    t.string "state_payment_status", comment: "支払状態"
    t.string "delay_text", comment: "遅延情報"
    t.string "state_payment_sight_change", comment: "支払変更"
    t.string "sight_change_text"
    t.string "other_cg"
    t.integer "state_creditguarantee_hopeful", comment: "希望保証額"
    t.integer "creditguarantee_drafut", comment: "初期保証額"
    t.integer "creditguarantee_fix", comment: "決定保証額"
    t.string "field30"
    t.string "reinsurance", comment: "再保険"
    t.integer "gaku_reinsurance", comment: "再保険額"
    t.text "reinsurance_gmo", comment: "再保険GMO"
    t.integer "gaku_reinsurance_gmo", comment: "再保険額GMO"
    t.string "biko", comment: "備考"
    t.string "tsr_corporate_code", comment: "TSRコード"
    t.string "tsr_report", comment: "TSRレポート"
    t.string "tsr_scoer", comment: "TSR点数"
    t.string "tsr_text", comment: "TSRテキスト"
    t.string "toki_corporate_code", comment: "登記コード"
    t.string "toki_report", comment: "登記レポート"
    t.string "toki_text", comment: "登記テキスト"
    t.string "tdb_corporate_code", comment: "帝国コード"
    t.string "tdb_report", comment: "帝国レポート"
    t.string "tdb_scoer", comment: "帝国点数"
    t.string "tdb_text", comment: "帝国テキスト"
    t.string "shinko_corporate_code", comment: "振興コード"
    t.string "shinko_reprt", comment: "振興レポート"
    t.string "shinko_scoer", comment: "振興点数"
    t.string "shinko_text", comment: "振興テキスト"
    t.string "taxagency_corporate_number", comment: "法人番号"
    t.string "taxagency_text", comment: "法人テキスト"
    t.string "bl_umu", comment: "BL有無"
    t.string "text", comment: "テキスト"
    t.string "bl_mark_1", comment: "BLマーク１"
    t.string "bl_mark_1_text", comment: "BLマーク１テキスト"
    t.string "bl_mark_2", comment: "BLマーク２"
    t.string "bl_mark_2_text", comment: "BLマーク２テキスト"
    t.string "hansha", comment: "販社"
    t.string "hp", comment: "ホームページ"
    t.string "hp_url", comment: "HPURL"
    t.string "hp_text", comment: "HPテキスト"
    t.string "zaiseki", comment: "在籍"
    t.string "gyosei_shobun", comment: "行政処分"
    t.string "gyosei_shobun_text", comment: "行政処分テキスト"
    t.string "oya", comment: "親会社"
    t.string "oya_bl", comment: "親会社BL"
    t.string "joujou", comment: "上場"
    t.string "joujou2", comment: "上場２"
    t.string "bspl", comment: "BSPL"
    t.string "oys_hp", comment: "親会社HP"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["corporate_code"], name: "IDX_ACCS_SK"
  end

  create_table "alarm_candidates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アラーム情報の候補", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスターID"
    t.string "crawler_table_name", limit: 127, null: false, comment: "テーブル名"
    t.integer "crawler_record_id", null: false, comment: "元データのID"
    t.integer "judge_id", comment: "審査員 ID"
    t.integer "alarm_id", comment: "承認後のアラームのID"
    t.integer "candidate_status", default: 0, comment: "承認ステータス 0:未承認 1:アラーム承認 2:アラーム破棄"
    t.integer "alarm_level", comment: "アラームレベル"
    t.string "alarm_source_code", limit: 4, comment: "アラームソースコード"
    t.string "detail_code_1", limit: 4, comment: "内容コード１"
    t.string "detail_code_2", limit: 4, comment: "内容コード２"
    t.text "link", comment: "リンク"
    t.datetime "alarm_date", comment: "アラーム日時"
    t.string "announce_info", limit: 1000, comment: "告知内容"
    t.string "memo", limit: 2000, comment: "メモ"
    t.string "doc_path", comment: "資料パス"
    t.string "img_path", comment: "画像パス"
    t.boolean "text_extraction_executed_flag", default: false, null: false, comment: "本文抽出実行フラグ（1:実行済み、0:未実行)"
    t.text "text_extraction_value", comment: "本文自体を保持"
    t.text "text_extraction_word_set", comment: "カンマ区切りwordセット（名詞、動詞、形容詞）"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.boolean "review_check_flag", default: false, null: false, comment: "レビューを確認したかどうか 0:未確認 1:確認済み"
    t.integer "reviewer_judge_id", comment: "レビューを実行した人の judge.id"
    t.index ["customer_master_id"], name: "customer_master_id"
    t.index ["judge_id"], name: "judge_id"
  end

  create_table "alarm_mail_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アラームメール送信リスト", force: :cascade do |t|
    t.integer "alarm_id", comment: "アラームID"
    t.integer "member_id", comment: "会員ID"
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.integer "mail_send_code", default: 0, comment: "送信メール種別コード"
    t.boolean "send_flag", default: false, null: false, comment: "送信フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "alarm_prtimes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PRTIMESアラームレベルの予測値", force: :cascade do |t|
    t.integer "crawl_prtimes_check_list_id", null: false, comment: "クロールリストID"
    t.integer "alarm_level", null: false, comment: "アラームレベル"
    t.float "alarm_proba", null: false, comment: "予測確率"
    t.index ["crawl_prtimes_check_list_id"], name: "crawl_prtimes_check_list_id"
  end

  create_table "alarms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アラーム情報", force: :cascade do |t|
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.integer "alarm_level", comment: "アラームレベル"
    t.string "alarm_source_code", limit: 4, comment: "アラームソースコード"
    t.string "detail_code_1", limit: 4, comment: "内容コード１"
    t.string "detail_code_2", limit: 4, comment: "内容コード２"
    t.string "association_code_1", limit: 4, comment: "関連コード１"
    t.string "association_code_2", limit: 4, comment: "関連コード２"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.text "link", comment: "リンク"
    t.datetime "alarm_date", comment: "アラーム日時"
    t.string "announce_info", limit: 1000, comment: "告知内容"
    t.string "memo", limit: 2000, comment: "メモ"
    t.string "doc_path", comment: "資料パス"
    t.string "img_path", comment: "画像パス"
    t.boolean "text_extraction_executed_flag", default: false, null: false, comment: "本文抽出実行フラグ（1:実行済み、0:未実行)"
    t.text "text_extraction_value", comment: "本文自体を保持"
    t.text "text_extraction_word_set", comment: "カンマ区切りwordセット（名詞、動詞、形容詞）"
    t.index ["customer_master_id"], name: "fk_rails_3ee6a3ebcd"
  end

  create_table "alliance_members", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "提携会員", force: :cascade do |t|
    t.integer "alliance_type", null: false, comment: "提携種別\t1:roborobo"
    t.string "alliance_unq_id", limit: 20, null: false, comment: "提携先ユニークID"
    t.integer "member_id", null: false, comment: "会員ID"
    t.string "member_name", limit: 50, null: false, comment: "会員名"
    t.string "email", null: false, comment: "メールアドレス"
    t.datetime "alliance_date", comment: "契約日時"
    t.boolean "inquiry_flag", default: false, null: false, comment: "問い合わせフラグ"
    t.text "memo", comment: "メモ"
    t.boolean "delete_flag", comment: "削除フラグ"
    t.datetime "delete_date", comment: "削除日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["alliance_type", "alliance_unq_id"], name: "IDX_ALLIANCE"
    t.index ["member_id"], name: "member_id"
  end

  create_table "api_access_logs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "APIのアクセスログ", force: :cascade do |t|
    t.datetime "called_at", comment: "呼び出し日時"
    t.string "token", comment: "トークン"
    t.string "ip_address", comment: "IPアドレス"
    t.integer "user_id", comment: "ユーザーID"
    t.integer "member_id", comment: "会員ID"
    t.string "method", comment: "HTTPメソッド"
    t.string "path", comment: "アクセス先パス"
    t.text "parameters", comment: "リクエストパラメータ"
    t.integer "response_code", comment: "レスポンスコード"
    t.datetime "created_at", comment: "作成日時"
  end

  create_table "blogs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "ブログ", force: :cascade do |t|
    t.string "title", limit: 40, null: false, comment: "タイトル"
    t.text "link", null: false, comment: "リンク"
    t.datetime "start_date", null: false, comment: "表示開始日時"
    t.datetime "end_date", null: false, comment: "表示終了日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["id", "start_date"], name: "IDX_BLOG"
  end

  create_table "by_agents", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "BY取次店", force: :cascade do |t|
    t.string "agent_code", limit: 3, comment: "取次店コード"
    t.string "agent_name", limit: 50, null: false, comment: "取次店名"
    t.integer "agent_type", null: false, comment: "取次店区分\t1:一般・共同商品、2:再保証"
    t.float "init_charge_rate", comment: "初回保証料 率"
    t.integer "init_charge_min", comment: "初回保証料 最低額"
    t.integer "init_charge_default", comment: "初回保証料 固定額"
    t.float "init_reassurance_rate", comment: "初回再保証料 率"
    t.integer "init_reassurance_min", comment: "初回再保証料 最低額"
    t.integer "init_reassurance_default", comment: "初回再保証料 固定額"
    t.float "yearly_charge_rate", comment: "年間保証料 率"
    t.integer "yearly_charge_min", comment: "年間保証料 最低額"
    t.integer "yearly_charge_def", comment: "年間保証料 固定額"
    t.integer "yearly_charge_max", comment: "年間保証料 上限額"
    t.float "yearly_reassurance_rate", comment: "年間再保証料 率"
    t.integer "yearly_reassurance_min", comment: "年間再保証料 最低額"
    t.integer "yearly_reassurance_def", comment: "年間再保証料 固定額"
    t.integer "restoration_costs", comment: "原状回復費用"
    t.integer "removal_remnant_costs", comment: "残置物撤去費用"
    t.integer "litigation_costs", comment: "訴訟費用"
    t.boolean "num_set_flag", comment: "番号設定フラグ\ttrue:必須"
    t.integer "approval_num", comment: "稟議/承認番号"
    t.text "mail_address", comment: "メール送付先"
    t.string "zip_password", limit: 20, comment: "ZIPパスワード"
    t.text "memo", comment: "メモ"
    t.integer "employee_id", comment: "入力者ID"
    t.boolean "delete_flag", comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["employee_id"], name: "FK_BY_AGT_EMPLOYEE"
  end

  create_table "by_customers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "BY申込人", force: :cascade do |t|
    t.integer "entity_id", comment: "エンティティID"
    t.string "customer_name", limit: 50, null: false, comment: "申込人名(顧客入力)"
    t.integer "prefecture_code", comment: "都道県コード"
    t.string "address", comment: "住所"
    t.string "daihyo_name", limit: 30, comment: "代表者名"
    t.string "daihyo_name2", limit: 30, comment: "代表者名2"
    t.string "daihyo_name3", limit: 30, comment: "代表者名3"
    t.string "daihyo_name4", limit: 30, comment: "代表者名4"
    t.string "daihyo_name5", limit: 30, comment: "代表者名5"
    t.string "daihyo_tel", limit: 11, comment: "代表電話番号"
    t.string "established", limit: 20, comment: "設立年月"
    t.bigint "capital", comment: "資本金"
    t.bigint "annual_sales", comment: "年商"
    t.string "business_content", limit: 50, comment: "事業内容"
    t.string "tanto_name", limit: 30, comment: "担当者名"
    t.string "tanto_tel", limit: 11, comment: "担当者電話番号"
    t.string "industry_code", limit: 2, comment: "業種コード"
    t.string "url", limit: 1000, comment: "URL"
    t.string "url2", limit: 1000, comment: "URL2"
    t.string "url3", limit: 1000, comment: "URL3"
    t.text "memo", comment: "メモ"
    t.integer "employee_id", comment: "入力者ID"
    t.integer "lock_employee_id", comment: "ロック保持者ID"
    t.boolean "temporarily_save_flag", comment: "一時保存フラグ"
    t.boolean "delete_flag", comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["employee_id"], name: "FK_BY_CST_EMPLOYEE"
    t.index ["entity_id"], name: "FK_BY_CST_ENTITY"
  end

  create_table "by_examinations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "BY審査", force: :cascade do |t|
    t.integer "by_customer_id", null: false, comment: "申込人ID"
    t.boolean "latest_flag", default: false, null: false, comment: "申込人別最新フラグ"
    t.date "examination_date", comment: "審査日"
    t.string "identification", limit: 20, comment: "本人確認"
    t.string "tsr_code", limit: 12, comment: "TSRコード"
    t.string "tsr_month", limit: 6, comment: "TSR調査年月(YYYYMM)"
    t.string "tsr_doc_path", comment: "TSR資料パス"
    t.string "tsr_corp_info", limit: 2, comment: "TSR企業情報"
    t.boolean "tsr_acquire_flag", comment: "TSR取得フラグ"
    t.string "tsr_score", limit: 3, comment: "TSR評点"
    t.text "tsr_memo", comment: "TSRメモ"
    t.text "other_memo", comment: "他保証メモ"
    t.text "past_memo", comment: "過去審査メモ"
    t.text "bl_memo", comment: "不芳情報メモ"
    t.string "bl_url1", limit: 1000, comment: "不芳情報URL1"
    t.string "bl_url2", limit: 1000, comment: "不芳情報URL2"
    t.string "bl_url3", limit: 1000, comment: "不芳情報URL3"
    t.text "bankrupt_memo", comment: "倒産メモ"
    t.string "bankrupt_url1", limit: 1000, comment: "倒産情報URL1"
    t.string "bankrupt_url2", limit: 1000, comment: "倒産情報URL2"
    t.string "bankrupt_url3", limit: 1000, comment: "倒産情報URL3"
    t.text "anti_social_memo", comment: "反社メモ"
    t.string "anti_social_url1", limit: 1000, comment: "反社情報URL1"
    t.string "anti_social_url2", limit: 1000, comment: "反社情報URL2"
    t.string "anti_social_url3", limit: 1000, comment: "反社情報URL3"
    t.text "memo", comment: "メモ"
    t.string "fin1_month", limit: 6, comment: "財務１年月(YYYYMM)"
    t.integer "fin1_assets", comment: "財務１資産(万円)"
    t.integer "fin1_liabilities", comment: "財務１負債(万円)"
    t.integer "fin1_earnings", comment: "財務１売上(万円)"
    t.integer "fin1_opr_profits", comment: "財務１営業利益(万円)"
    t.integer "fin1_profits", comment: "財務１純利益(万円)"
    t.string "fin2_month", limit: 6, comment: "財務２年月(YYYYMM)"
    t.integer "fin2_assets", comment: "財務２資産(万円)"
    t.integer "fin2_liabilities", comment: "財務２負債(万円)"
    t.integer "fin2_earnings", comment: "財務２売上(万円)"
    t.integer "fin2_opr_profits", comment: "財務２営業利益(万円)"
    t.integer "fin2_profits", comment: "財務２純利益(万円)"
    t.string "fin3_month", limit: 6, comment: "財務３年月(YYYYMM)"
    t.integer "fin3_assets", comment: "財務３資産(万円)"
    t.integer "fin3_liabilities", comment: "財務３負債(万円)"
    t.integer "fin3_earnings", comment: "財務３売上(万円)"
    t.integer "fin3_opr_profits", comment: "財務３営業利益(万円)"
    t.integer "fin3_profits", comment: "財務３純利益(万円)"
    t.integer "employee_id", comment: "入力者ID"
    t.integer "lock_employee_id", comment: "ロック保持者ID"
    t.boolean "delete_flag", comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["by_customer_id"], name: "FK_BY_EXM_CUSTOMER"
    t.index ["employee_id"], name: "FK_BY_EXM_EMPLOYEE"
  end

  create_table "by_guarantees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "BY保証", force: :cascade do |t|
    t.integer "by_thing_id", null: false, comment: "物件ID"
    t.integer "by_customer_id", null: false, comment: "申込人ID"
    t.date "start_date", comment: "保証開始日"
    t.date "end_date", comment: "保証終了日"
    t.string "accounting_month", limit: 6, comment: "売上計上年月"
    t.date "scheduled_end_date", comment: "保証終了予定日"
    t.text "contact", comment: "先方連絡内容"
    t.integer "billing_ammount", comment: "請求額"
    t.integer "deposit_ammount", comment: "入金額"
    t.date "delivery_date", comment: "請求書送付日"
    t.date "deposit_date", comment: "入金日"
    t.string "deposit_status", limit: 1, default: "0", comment: "入金ステータス\t0:未、1:一部、2:全"
    t.text "memo", comment: "メモ"
    t.integer "employee_id", comment: "入力者ID"
    t.integer "lock_employee_id", comment: "ロック保持者ID"
    t.boolean "delete_flag", comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["by_thing_id"], name: "FK_BY_GRT_THING"
    t.index ["employee_id"], name: "FK_BY_GRT_EMPLOYEE"
  end

  create_table "by_things", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "BY物件", force: :cascade do |t|
    t.integer "by_agent_id", null: false, comment: "取次店ID"
    t.integer "by_customer_id", null: false, comment: "申込人ID"
    t.string "thing_name", limit: 50, comment: "物件名"
    t.string "base_agent_name", limit: 50, comment: "再保証取次店名"
    t.integer "thing_type", comment: "物件種別\t1:店舗、2:事務所"
    t.integer "prefecture_code", comment: "都道県コード"
    t.string "address", comment: "住所"
    t.string "industry_code", limit: 2, comment: "業種コード"
    t.integer "deposit", comment: "保証金額"
    t.integer "repayment", comment: "償却金額"
    t.integer "monthly_rent", comment: "月額賃料"
    t.integer "admin_fee", comment: "管理費"
    t.string "ammount1_name", limit: 10, comment: "その他金額1名称"
    t.integer "ammount1_val", comment: "その他金額1"
    t.string "ammount2_name", limit: 10, comment: "その他金額2名称"
    t.integer "ammount2_val", comment: "その他金額2"
    t.string "ammount3_name", limit: 10, comment: "その他金額3名称"
    t.integer "ammount3_val", comment: "その他金額3"
    t.integer "init_charge", comment: "初回保証料"
    t.float "init_charge_rate", comment: "初回保証料 率"
    t.integer "init_reassurance", comment: "初回再保証料"
    t.float "init_reassurance_rate", comment: "初回再保証料 率"
    t.integer "yearly_charge", comment: "年間保証料"
    t.float "yearly_charge_rate", comment: "年間保証料 率"
    t.integer "yearly_reassurance", comment: "年間再保証料"
    t.float "yearly_reassurance_rate", comment: "年間再保証料 率"
    t.integer "restoration_costs", comment: "原状回復費用"
    t.integer "removal_remnant_costs", comment: "残置物撤去費用"
    t.integer "litigation_costs", comment: "訴訟費用"
    t.integer "month_term", comment: "期間月数"
    t.integer "guarantee_term", comment: "保証期間月数"
    t.string "reason", limit: 30, comment: "申込理由"
    t.string "emergency_contact", limit: 30, comment: "緊急連絡先"
    t.string "emergency_contact_tel", limit: 11, comment: "緊急連絡先電話番号"
    t.text "emergency_contact_memo", comment: "緊急連絡先メモ"
    t.string "emergency_contact_url1", limit: 1000, comment: "緊急連絡先URL1"
    t.string "emergency_contact_url2", limit: 1000, comment: "緊急連絡先URL2"
    t.string "emergency_contact_url3", limit: 1000, comment: "緊急連絡先URL3"
    t.string "rentai_name", limit: 30, comment: "連帯保証人名"
    t.string "rentai_tel", limit: 11, comment: "連帯保証人電話番号"
    t.text "rentai_memo", comment: "連帯保証人メモ"
    t.string "rentai_url1", limit: 1000, comment: "連帯保証人URL1"
    t.string "rentai_url2", limit: 1000, comment: "連帯保証人URL2"
    t.string "rentai_url3", limit: 1000, comment: "連帯保証人URL3"
    t.string "map_url", limit: 1000, comment: "物件地図URL"
    t.text "tel_memo", comment: "電話確認メモ"
    t.text "memo", comment: "メモ"
    t.text "communicate_memo", comment: "連絡メモ"
    t.float "substance_deposit", comment: "敷金/保証金額（実質）"
    t.boolean "pass_flag", comment: "可決フラグ\ttrue:可決、false:否決"
    t.date "approval_request_date", comment: "稟議申請日"
    t.date "approval_date", comment: "承認日"
    t.string "reject_reason_code1", limit: 2, comment: "否決理由コード1"
    t.string "reject_reason_code2", limit: 2, comment: "否決理由コード2"
    t.text "approval_reason_text", comment: "決済理由 文章"
    t.string "approval_num", limit: 20, comment: "稟議/承認番号"
    t.string "agent_issue_num", limit: 20, comment: "取次店発行番号"
    t.boolean "combined_housing", default: false, comment: "兼住宅フラグ"
    t.text "approval_condition", comment: "決済条件"
    t.boolean "export_flag", default: false, comment: "出力フラグ\ttrue:済、false:未"
    t.string "status", limit: 2, null: false, comment: "ステータス"
    t.integer "approval_request_id", comment: "稟議申請者ID"
    t.boolean "cancel_flag", comment: "キャンセルフラグ    true:キャンセル"
    t.integer "pre_by_customer_id", comment: "前回申込人ID"
    t.integer "authorizer_id", comment: "決裁者ID"
    t.integer "employee_id", comment: "入力者ID"
    t.integer "lock_employee_id", comment: "ロック保持者ID"
    t.boolean "delete_flag", comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["by_agent_id"], name: "FK_BY_THN_AGENT"
    t.index ["by_customer_id"], name: "FK_BY_THN_CUSTOMER"
    t.index ["employee_id"], name: "FK_BY_THN_EMPLOYEE"
  end

  create_table "cache_nikkei_articles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "日経新聞記事保存用", force: :cascade do |t|
    t.string "permalink", null: false, comment: "パーマリンク"
    t.string "title", null: false, comment: "タイトル"
    t.text "body", null: false, comment: "本文"
    t.datetime "published_at", null: false, comment: "公開日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["permalink"], name: "IDX_CRAWLERLOG"
    t.index ["permalink"], name: "permalink", unique: true
  end

  create_table "card_masters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "カードマスター", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.string "payjp_customer_id", null: false, comment: "PAYJP顧客ID"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "fk_rails_1a0f342e44"
  end

  create_table "cards", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "カード情報", force: :cascade do |t|
    t.integer "card_master_id", comment: "カードマスターID"
    t.string "payjp_card_id", null: false, comment: "PAYJPカードID"
    t.boolean "default_flag", default: false, null: false, comment: "デフォルトカードフラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["card_master_id"], name: "fk_rails_48f0be08ba"
  end

  create_table "chk_entity", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "ID", force: :cascade do |t|
    t.integer "match_type", comment: "一致タイプ"
    t.integer "entity_id", comment: "エンティティID"
    t.string "corporation_number", comment: "法人番号"
    t.string "corporation_name", comment: "法人名"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.string "address", comment: "住所"
    t.index ["corporation_number"], name: "IDX_0719_02"
    t.index ["entity_id"], name: "IDX_0719_01"
    t.index ["match_type"], name: "IDX_0719_03"
  end

  create_table "code_prtimes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PRTIMES詳細コードの予測値", force: :cascade do |t|
    t.integer "crawl_prtimes_check_list_id", null: false, comment: "クロールリストID"
    t.integer "code_details", null: false, comment: "コード"
    t.float "code_proba", comment: "予測確率"
    t.index ["crawl_prtimes_check_list_id"], name: "crawl_prtimes_check_list_id"
  end

  create_table "company_scores", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "会社番付情報", force: :cascade do |t|
    t.integer "entity_id", comment: "エンティティID"
    t.string "cs_id", limit: 20, null: false, comment: "会社番付ID"
    t.string "company_name", limit: 150, null: false, comment: "企業名"
    t.string "corporation_number", limit: 13, comment: "法人番号"
    t.string "score", limit: 10, comment: "評点"
    t.string "zip_code", limit: 8, comment: "郵便番号"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.string "address", comment: "住所"
    t.string "tel", limit: 13, comment: "電話番号"
    t.string "catergory", limit: 100, comment: "大分類"
    t.string "sub_catergory", limit: 100, comment: "小分類"
    t.string "url", comment: "URL"
    t.string "specific_status", limit: 1, null: false, comment: "特定状態"
    t.text "memo", comment: "メモ"
    t.date "acquired_date", null: false, comment: "取得日"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["cs_id"], name: "IDX_CSCR_CS_ID"
    t.index ["entity_id"], name: "IDX_CSCR_ENT_ID"
  end

  create_table "contact_sikihou_datas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "上場四季報情報", force: :cascade do |t|
    t.integer "entity_id", comment: "エンティティID"
    t.integer "securities_code", comment: "証券コード"
    t.string "company_name", limit: 200, comment: "会社名"
    t.string "category", limit: 50, comment: "業種"
    t.string "address", comment: "住所"
    t.string "tel", limit: 11, comment: "電話番号"
    t.string "stock_market", comment: "上場区分"
    t.boolean "contact_flag", default: false, comment: "連絡フラグ"
    t.string "memo", comment: "メモ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "corporation_watchers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "法人ウォッチャー", force: :cascade do |t|
    t.integer "process", null: false, comment: "区分処理"
    t.text "change_cause", comment: "変更事由の詳細"
    t.string "close_cause", comment: "登記記録の閉鎖等の事由"
    t.string "change_date", comment: "変更年月日"
    t.text "url", comment: "URLリンク"
    t.integer "alarm_flag", default: 0, comment: "チェックフラグ"
    t.integer "alarm_level", comment: "アラームレベル"
    t.text "memo", comment: "備考"
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.integer "entity_id", comment: "エンティティID"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["alarm_flag"], name: "index_corporation_watchers_alarm_flag"
    t.index ["customer_master_id"], name: "fkey_customer_master"
    t.index ["entity_id"], name: "corporation_watchers_ibfk_1"
  end

  create_table "coupons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "クーポン情報", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.string "coupon_code", comment: "クーポンコード"
    t.datetime "created_at", comment: "登録日時"
    t.datetime "updated_at", comment: "更新日時"
  end

  create_table "crawl_google_check_lists", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "グーグル検索チェックリスト", force: :cascade do |t|
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.string "title", comment: "タイトル"
    t.text "link", comment: "リンク"
    t.text "snippet", comment: "スニペット"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.integer "google_crawl_type_code", comment: "クロール種別コード"
    t.text "url", comment: "URL"
    t.text "word", comment: "検索ワード"
    t.index ["customer_master_id"], name: "fk_rails_457355659c"
  end

  create_table "crawl_google_difference_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "グーグル検索差分リスト", force: :cascade do |t|
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.string "title", comment: "タイトル"
    t.text "link", comment: "リンク"
    t.text "snippet", comment: "スニペット"
    t.boolean "check_flag", default: true, null: false, comment: "チェックフラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.integer "google_crawl_type_code", comment: "クロール種別コード"
    t.text "url", comment: "URL"
    t.text "word", comment: "検索ワード"
    t.integer "alarm_learning_code", default: 0, null: false, comment: "アラーム学習コード"
    t.boolean "url_click_flag", default: false, null: false, comment: "URLクリックフラグ"
    t.boolean "alarm_pred_flag", default: false, null: false, comment: "機械学習実施フラグ"
    t.float "alarm_pred", default: 0.0, null: false, comment: "アラーム確立"
    t.boolean "later_flag", default: false, comment: "後回しフラグ"
    t.text "text_extraction_value", comment: "本文自体を保持"
    t.text "text_extraction_word_set", comment: "カンマ区切りwordセット（名詞、動詞、形容詞）"
    t.integer "already_reported_pred", default: 0, null: false, comment: "既報確率（四捨五入）"
    t.integer "alarm_bert_prob", default: 0, null: false, comment: "BERT判定確立：小数点第一位を四捨五入"
    t.integer "learning_code", default: 1, null: false, comment: "機械学習状態制御コード(1:対象 2:処理中 3:完了)"
    t.index ["alarm_learning_code"], name: "idx_cgdl_alc"
    t.index ["check_flag"], name: "cgdl_cf"
    t.index ["created_at"], name: "idx_cgdl_created_at"
    t.index ["customer_master_id"], name: "fk_rails_a3df897a75"
  end

  create_table "crawl_lighthouse_check_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "Lighthouseの口コミ情報", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスタID"
    t.datetime "post_date", null: false, comment: "投稿日"
    t.integer "experienced_year", comment: "在籍年"
    t.string "title", null: false, comment: "表題"
    t.string "link", null: false, comment: "URLリンク"
    t.text "comment", null: false, comment: "コメント"
    t.boolean "check_flag", default: false, comment: "確認済フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id"], name: "customer_master_id"
  end

  create_table "crawl_nikkei_check_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "日経新聞記事情報", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスタID"
    t.datetime "published_at", null: false, comment: "公開日時"
    t.string "title", null: false, comment: "表題"
    t.string "link", null: false, comment: "URLリンク"
    t.boolean "check_flag", default: false, comment: "確認済フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["check_flag"], name: "index_crawl_nikkei_check_lists"
    t.index ["customer_master_id"], name: "customer_master_id"
  end

  create_table "crawl_prtimes_check_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PRTimes記事情報", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスタID"
    t.datetime "release_date", null: false, comment: "リリース時刻"
    t.string "title", null: false, comment: "表題"
    t.string "link", null: false, comment: "URLリンク"
    t.string "sub_title", comment: "サブタイトル"
    t.string "body", limit: 10000, null: false, comment: "本文"
    t.boolean "check_flag", default: false, comment: "確認済フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["check_flag"], name: "index_crawl_prtimes_check_lists"
    t.index ["customer_master_id"], name: "customer_master_id"
  end

  create_table "crawl_tdnet_check_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "TDnet開示情報", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスターID"
    t.datetime "disclosed_date", null: false, comment: "開示時刻"
    t.integer "securities_code", null: false, comment: "銘柄コード"
    t.string "title", null: false, comment: "表題"
    t.string "link", null: false, comment: "URLリンク"
    t.boolean "check_flag", default: false, comment: "確認済フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["check_flag"], name: "index_crawl_tdnet_check_lists"
    t.index ["customer_master_id"], name: "fk_customer_master"
  end

  create_table "crawl_tenshokukaigi_check_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "転職会議の評判情報", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスタID"
    t.datetime "post_date", null: false, comment: "投稿時刻"
    t.integer "experienced_year", comment: "在籍年"
    t.string "title", null: false, comment: "表題"
    t.string "link", null: false, comment: "URLリンク"
    t.text "bad_point", null: false, comment: "気になること"
    t.boolean "check_flag", default: false, comment: "確認済フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["check_flag"], name: "index_crawl_tenshokukaigi_check_lists"
    t.index ["customer_master_id"], name: "customer_master_id"
  end

  create_table "crawl_twitter_check_lists", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "ツイッター検索結果リスト", force: :cascade do |t|
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.string "tw_id", comment: "ツイッターID"
    t.string "screen_name", comment: "画面名"
    t.string "user_name", comment: "ツイッターユーザ名"
    t.datetime "tweet_date", comment: "投稿日時"
    t.text "link", comment: "リンク"
    t.text "message", comment: "内容"
    t.text "word", comment: "検索ワード"
    t.integer "twitter_crawl_type_code", comment: "クロール種別コード"
    t.boolean "check_flag", default: true, null: false, comment: "チェックフラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["check_flag"], name: "index_crawl_twitter_check_lists"
    t.index ["customer_master_id"], name: "fk_rails_c16ce0bdc2"
  end

  create_table "crawler_logs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "クローラーログ", force: :cascade do |t|
    t.integer "crawler_type", null: false, comment: "クローラーの種類"
    t.string "exec_options", default: "", null: false, comment: "クローラー起動時のオプション"
    t.integer "status", null: false, comment: "クローラーステータス(処理中、正常終了、異常終了)"
    t.datetime "started_at", null: false, comment: "クローラー開始日時"
    t.datetime "ended_at", comment: "クローラー終了日時"
    t.integer "requested_count", default: 0, null: false, comment: "API等へのアクセス回数"
    t.integer "retrieved_count", default: 0, null: false, comment: "取得した件数"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["id", "crawler_type"], name: "IDX_CRAWLERLOG"
  end

  create_table "credits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "信用状況", force: :cascade do |t|
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.integer "credit_level", comment: "評価レベル"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id"], name: "fk_rails_8ef2662ca3"
  end

  create_table "crm_kairos_lead_infos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "CRM_Kairosリード情報", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.integer "employee_id", comment: "担当社員ID"
    t.string "user_name", comment: "氏名"
    t.string "company_name", comment: "会社名"
    t.string "email", comment: "メールアドレス"
    t.string "department", comment: "部署"
    t.string "position", comment: "役職"
    t.string "tel", limit: 20, comment: "電話番号"
    t.text "lead_tags", comment: "リードタグ"
    t.string "area", limit: 1, comment: "エリア\t1:東京、2:大阪、3:名古屋"
    t.string "status", limit: 1, null: false, comment: "状態\t0:未連絡、1:連絡中、8:対象外、9:登録済"
    t.text "memo", comment: "メモ"
    t.text "kairos_comment", comment: "kairosコメント"
    t.datetime "kairos_created_at", null: false, comment: "kairos登録日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["employee_id"], name: "FK_KAIROS_LEAD_EMPLOYEE"
    t.index ["member_id"], name: "FK_KAIROS_LEAD_MEMBER"
  end

  create_table "crm_member_lead_infos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "CRM_会員リード情報", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.integer "employee_id", comment: "担当社員ID"
    t.string "area", limit: 1, comment: "エリア\t1:東京、2:大阪、3:名古屋"
    t.string "status", limit: 1, comment: "状態\t0:未連絡、1:連絡中、8:対象外、9:登録済"
    t.text "memo", comment: "メモ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["employee_id"], name: "FK_MEMBER_LEAD_EMPLOYEE"
    t.index ["member_id"], name: "FK_MEMBER_LEAD_MEMBER"
  end

  create_table "customer_master_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "取引先マスター履歴", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスターID"
    t.string "customer_name", comment: "取引先名"
    t.string "daihyo_name", comment: "代表者名"
    t.string "address", comment: "住所"
    t.string "corporation_number", comment: "法人番号"
    t.integer "touki_confirmation_code", comment: "登記確認コード"
    t.integer "hp_confirmation_code", comment: "HP確認コード"
    t.text "url_1", comment: "URL1"
    t.text "url_2", comment: "URL2"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id"], name: "customer_master_id"
  end

  create_table "customer_masters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "取引先マスター", force: :cascade do |t|
    t.string "house_company_code", comment: "内部企業コード"
    t.string "daihyo_name", comment: "代表者名"
    t.string "corporation_number", comment: "法人番号"
    t.integer "touki_confirmation_code", default: 0, comment: "登記確認コード"
    t.integer "hp_confirmation_code", default: 0, comment: "ホームページ確認コード"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.text "url_1", comment: "URL１"
    t.text "url_2", comment: "URL２"
    t.string "address", comment: "住所"
    t.string "customer_name", comment: "取引先名"
    t.integer "img_dl_code_1", default: 0, comment: "企業サイトダウンロードコード"
    t.integer "img_dl_code_2", default: 0, comment: "WEBサイトダウンロードコード"
    t.boolean "daily_crawl_flag", default: true, null: false, comment: "日次クロールフラグ"
    t.text "daily_crawl_keyword", comment: "日次クロールキーワード"
    t.boolean "houjinkaku_remove_flag", default: true, null: false, comment: "法人格削除フラグ"
    t.text "memo", comment: "メモ"
    t.index ["corporation_number"], name: "IDX_CM_CORPORATION_NUMBER"
    t.index ["house_company_code"], name: "IDX_CM_HOUSE_COMPANY_CODE"
    t.index ["house_company_code"], name: "house_company_code", unique: true
  end

  create_table "customer_registration_counts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "取引先登録数", force: :cascade do |t|
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.datetime "registration_month", null: false, comment: "登録年月"
    t.integer "count", default: 0, null: false, comment: "回数"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id", "registration_month"], name: "cmrm_index", unique: true
  end

  create_table "customers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "取引先", force: :cascade do |t|
    t.integer "user_id", comment: "ユーザーID"
    t.integer "member_id", comment: "会員ID"
    t.string "house_company_code", comment: "内部企業コード"
    t.string "corporation_number", comment: "法人番号"
    t.string "customer_name", comment: "取引先名"
    t.string "zip_code", comment: "郵便番号"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.string "address1", comment: "住所１"
    t.string "address2", comment: "住所２"
    t.string "daihyo_name", comment: "代表者名"
    t.string "daihyo_tel", comment: "代表電話番号"
    t.integer "deal_term_code", comment: "取引年数コード"
    t.integer "payment_status_code", comment: "支払状況コード"
    t.integer "setting_reason_code", comment: "設定理由コード"
    t.text "url"
    t.text "special", comment: "特筆事項"
    t.text "concern", comment: "懸念事項"
    t.string "member_memo", limit: 400, comment: "会員によるメモ"
    t.datetime "member_memo_at", comment: "メモされた日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.boolean "delete_flag", default: false, null: false, comment: "削除フラグ"
    t.datetime "delete_time", comment: "削除日時"
    t.string "salesforce_account_id", comment: "セールスフォースアカウントID"
    t.integer "salesforce_user_id", comment: "セールスフォースアユーザーID"
    t.integer "employee_id", comment: "審査社員ID"
    t.string "status", limit: 1, default: "0", comment: "状態"
    t.date "comp_request_date", comment: "審査完了要望日"
    t.string "sb_client_code", limit: 11, comment: "ＳＢクライアントコード"
    t.boolean "recommended_flag", default: false, comment: "レコメンド判別フラグ"
    t.boolean "robo_past_flag", default: false, comment: "ロボロボ過去審査フラグ"
    t.datetime "related_to_cm_at", comment: "取引先設定完了日時"
    t.datetime "alarm_investigate_limit", null: false, comment: "過去調査有効期限"
    t.datetime "alarm_investigate_before_limit", comment: "過去調査有効期限(閲覧期限解除前)"
    t.index ["customer_master_id"], name: "idx_cs_cmi"
    t.index ["member_id"], name: "fk_rails_ca7932d44f"
  end

  create_table "dialogs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "顧客対話", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "v1_employee_id", null: false, comment: "社員ID"
    t.string "topic_code", limit: 2, comment: "トピックコード"
    t.string "content", comment: "表題"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "dialogs_ibfk_1"
    t.index ["v1_employee_id"], name: "dialogs_ibfk_2"
  end

  create_table "employees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "社員情報", force: :cascade do |t|
    t.string "employee_name", limit: 30, null: false, comment: "社員名"
    t.string "password", limit: 20, null: false, comment: "パスワード"
    t.string "auth_flags", limit: 20, comment: "権限フラグ"
    t.boolean "available_flag", default: true, comment: "有効フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "entities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "法人", force: :cascade do |t|
    t.string "house_company_code", comment: "内部企業コード"
    t.string "corporation_number", comment: "法人番号"
    t.boolean "show_flag", default: false, null: false, comment: "表示フラグ"
    t.string "established", comment: "設立"
    t.integer "securities_code", comment: "証券コード"
    t.string "stock_market", comment: "上場市場"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["corporation_number"], name: "IDX_E_CORPORATION_NUMBER"
    t.index ["house_company_code"], name: "IDX_E_HOUSE_COMPANY_CODE"
    t.index ["securities_code"], name: "IDX_E_SECURITIES_CODE"
  end

  create_table "entity_candidates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "エンティティ候補", force: :cascade do |t|
    t.string "data_type", limit: 1, null: false, comment: "データ種別"
    t.integer "data_id", null: false, comment: "データID"
    t.integer "entity_id", null: false, comment: "エンティティID"
    t.integer "accuracy", null: false, comment: "確度"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["data_type", "data_id", "accuracy"], name: "IDX_ECD_DISP_ORDER"
  end

  create_table "entity_profiles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "法人概要", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "エンティティID"
    t.string "corporation_name", comment: "法人名"
    t.string "corporation_name_short", comment: "法人名略"
    t.string "corporation_name_kana", comment: "会社名カナ"
    t.string "corporation_name_compare", comment: "会社名比較用"
    t.string "zip_code", comment: "郵便番号"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.integer "prefecture_order", default: 0, null: false, comment: "都道府県オーダー"
    t.string "address", comment: "住所"
    t.string "daihyo_name", comment: "代表者名"
    t.string "daihyo_tel", comment: "代表電話番号"
    t.string "daihyo_fax", comment: "代表FAX番号"
    t.string "employee_number", comment: "従業員数"
    t.bigint "capital", comment: "資本金"
    t.bigint "capital_range_min", comment: "資本金範囲最小"
    t.bigint "capital_range_max", comment: "資本金範囲最大"
    t.string "capital_comment", limit: 30, comment: "資本金補足文言"
    t.string "finance_comment", limit: 30, comment: "財務補足文言"
    t.string "finance_graph_comment", limit: 30, comment: "財務グラフコメント"
    t.string "corporation_url", comment: "コーポレートサイト"
    t.string "social_insurance_code", limit: 1, comment: "社会保険加入フラグ"
    t.integer "payment_history", default: 0, null: false, comment: "支払履歴\t0:情報なし、1:正常な支払履歴（継続）、2:正常な支払履歴（過去）、3:懸念なし、4:やや懸念あり、5:懸念あり"
    t.text "anti_social_info", comment: "反社内容"
    t.text "ai_comment", comment: "AIコメント"
    t.text "human_comment", comment: "与信管理士コメント"
    t.datetime "info_update_date", comment: "最終更新日"
    t.datetime "investigation_date", comment: "最終調査日"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["corporation_name", "prefecture_order"], name: "IDX_EP_CORP_NAME"
    t.index ["corporation_name_compare"], name: "IDX_EP_CORPORATION_NAME_COMPARE"
    t.index ["corporation_name_short"], name: "FIDX_EP_NAME", type: :fulltext
    t.index ["corporation_name_short"], name: "IDX_EP_NAME_SHORT"
    t.index ["entity_id"], name: "IDX_ENTITY_ID"
    t.index ["prefecture_code", "address"], name: "IDX_EP_ADDRESS"
  end

  create_table "entity_relations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "法人関係", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "法人ID"
    t.integer "relation_entity_id", null: false, comment: "関係先 法人ID"
    t.boolean "parent_flag", default: false, null: false, comment: "親関係フラグ"
    t.boolean "same_daihyo_flag", default: false, null: false, comment: "代表者同一フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "entity_id"
    t.index ["relation_entity_id"], name: "relation_entity_id"
  end

  create_table "entity_tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "法人タグ", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "法人ID"
    t.string "tag_code", limit: 4, null: false, comment: "タグコード"
    t.boolean "main_flag", default: false, comment: "主タグフラグ"
    t.boolean "delete_flag", default: false, comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id", "tag_code"], name: "entity_id", unique: true
    t.index ["tag_code"], name: "tag_code"
  end

  create_table "entity_task_es_updates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "EntitiesテーブルEs更新バッチ履歴", force: :cascade do |t|
    t.datetime "started_at", null: false, comment: "開始日時"
    t.datetime "entity_ended_at", comment: "Entity更新終了日時"
    t.datetime "entity_profile_ended_at", comment: "EntityProfile更新終了日時"
    t.integer "entity_count", comment: "Entity更新件数"
    t.integer "entity_profile_count", comment: "EntityProfile更新件数"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "exam_details", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "調査詳細情報", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "取引先ID"
    t.integer "disp_order", null: false, comment: "表示順"
    t.text "link", comment: "リンク"
    t.date "accrual_date", comment: "発生日"
    t.string "doc_path", comment: "資料パス"
    t.text "research", comment: "調査内容"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "FK_EXD_ENTITY"
  end

  create_table "examinations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "審査情報", force: :cascade do |t|
    t.integer "customer_id", comment: "取引先ID"
    t.integer "purchase_id", comment: "企業購入情報ID"
    t.string "daihyo_name", comment: "代表者名"
    t.text "url_1", comment: "URL１"
    t.text "url_2", comment: "URL２"
    t.integer "credit_level", comment: "評価レベル"
    t.boolean "daily_crawl_flag", null: false, comment: "日次クロールフラグ"
    t.text "daily_crawl_keyword", comment: "日次クロールキーワード"
    t.boolean "houjinkaku_remove_flag", null: false, comment: "法人格削除フラグ"
    t.string "memo", limit: 2000, comment: "メモ"
    t.integer "salesforce_syncs_id", comment: "セールスフォース連携ID"
    t.string "salesforce_error_message", comment: "セールスフォースエラーメッセージ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_id"], name: "IDX_EXM_CST_ID"
    t.index ["purchase_id"], name: "IDX_EXM_PUR_ID"
  end

  create_table "exclude_entities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "除外法人", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "法人ID"
    t.text "memo", comment: "メモ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "entity_id"
  end

  create_table "fixed_phrase_masters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "定型文マスター", force: :cascade do |t|
    t.integer "phrase_type", null: false, comment: "文章種別\t1:アラーム通知内容、2:財務補足"
    t.integer "disp_order", null: false, comment: "表示順"
    t.string "title", limit: 20, null: false, comment: "タイトル"
    t.text "content", null: false, comment: "文言"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "grabs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "ユーザー(審査員)、取引先関連付け", force: :cascade do |t|
    t.integer "judge_id", null: false, comment: "ユーザーID"
    t.integer "customer_master_id", null: false, comment: "取引先マスタID"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id"], name: "customer_master_id", unique: true
    t.index ["judge_id"], name: "judge_id"
  end

  create_table "improvements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "改善箱", force: :cascade do |t|
    t.integer "user_id", comment: "ユーザーID"
    t.integer "member_id", comment: "会員ID"
    t.string "name", comment: "名前"
    t.string "email", comment: "メールアドレス"
    t.text "content", comment: "要望内容"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "fk_rails_8a9d9759a7"
  end

  create_table "internal_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "login_id", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_internal_users_on_email", unique: true
    t.index ["login_id"], name: "index_internal_users_on_login_id", unique: true
    t.index ["reset_password_token"], name: "index_internal_users_on_reset_password_token", unique: true
  end

  create_table "internalonly_requests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "社内用作業依頼", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "v1_employee_id", comment: "社員ID"
    t.integer "requester_v1_employee_id", comment: "依頼社員ID"
    t.string "type_code", limit: 2, comment: "種別"
    t.string "content", comment: "内容"
    t.string "status_code", limit: 1, default: "1", comment: "ステータス"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "internalonly_requests_ibfk_1"
  end

  create_table "job_talks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "転職会議情報", force: :cascade do |t|
    t.string "corporation_number", limit: 13, comment: "法人番号"
    t.string "industry", comment: "業界"
    t.bigint "capital", comment: "資本金"
    t.string "account_closing_month", comment: "決算月"
    t.integer "employee_number", comment: "従業員数"
    t.string "established", comment: "設立年月"
    t.string "zip_code", comment: "郵便番号"
    t.string "daihyo_name", comment: "代表者名"
    t.string "daihyo_tel", comment: "代表電話番号"
    t.string "daihyo_fax", comment: "代表FAX番号"
    t.string "corporation_url", comment: "コーポレートサイト"
    t.index ["corporation_number"], name: "IDX_JT_CORP_NUMBER"
  end

  create_table "jqgrid_col_infos", primary_key: ["id", "temp_id", "temp_index"], options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "JqGridカラム情報", force: :cascade do |t|
    t.integer "id", null: false, comment: "ID", auto_increment: true
    t.integer "temp_id", null: false, comment: "テンプレートID"
    t.string "temp_index", null: false, comment: "index名"
    t.string "temp_name", null: false, comment: "name属性"
    t.string "temp_label", null: false, comment: "ラベル名"
    t.integer "temp_width", null: false, comment: "サイズ"
    t.string "temp_align", limit: 10, comment: "表示位置"
    t.text "temp_option", comment: "オプション"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["id"], name: "IDX_NOTIFICATION"
  end

  create_table "jqgrid_col_templates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "JqGridテンプレートマスタ", force: :cascade do |t|
    t.string "jq_temp_name", comment: "テンプレート名"
    t.text "jq_temp_model", null: false, comment: "テンプレート内容"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["id"], name: "IDX_NOTIFICATION"
  end

  create_table "jqgrid_user_infos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "JqGridカラム順序", force: :cascade do |t|
    t.integer "jq_id", null: false, comment: "テンプレートID"
    t.integer "emplyee_id", null: false, comment: "社員ID"
    t.text "jq_order", null: false, comment: "順序"
    t.integer "jq_rowNum", null: false, comment: "ページ数"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["id"], name: "IDX_NOTIFICATION"
  end

  create_table "judges", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "審査者情報", force: :cascade do |t|
    t.string "email", default: "", null: false, comment: "Eメールアドレス"
    t.string "encrypted_password", default: "", null: false, comment: "暗号化パスワード"
    t.string "name", default: "", null: false
    t.integer "authority_code", default: 0, comment: "権限コード"
    t.integer "dept_code", comment: "部署コード"
    t.string "message", limit: 1023, comment: "メッセージ"
    t.string "photo", comment: "フォト"
    t.string "reset_password_token", comment: "リセットパスワードトークン"
    t.datetime "reset_password_sent_at", comment: "パスワードリセット日時"
    t.datetime "remember_created_at", comment: "devise用カラム"
    t.integer "sign_in_count", default: 0, null: false, comment: "接続回数"
    t.datetime "current_sign_in_at", comment: "最終ログイン日時"
    t.datetime "last_sign_in_at", comment: "前回ログイン日時"
    t.string "current_sign_in_ip", comment: "最終ログインIPアドレス"
    t.string "last_sign_in_ip", comment: "前回ログインIPアドレス"
    t.boolean "available_flag", default: true, null: false, comment: "有効フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["email"], name: "index_judges_on_email", unique: true
    t.index ["name"], name: "name", unique: true
    t.index ["reset_password_token"], name: "index_judges_on_reset_password_token", unique: true
  end

  create_table "kanpou_posts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "官報情報", force: :cascade do |t|
    t.integer "customer_master_id", comment: "取引先マスターID"
    t.string "post_date", comment: "送信日"
    t.string "post_category", comment: "送信カテゴリ"
    t.string "post_type", comment: "送信種別"
    t.string "post_number", comment: "送信番号"
    t.text "post_contents", comment: "送信内容"
    t.string "post_link", comment: "リンク"
    t.boolean "check_flag", default: true, null: false, comment: "チェックフラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["check_flag"], name: "index_kanpou_posts_check_flag"
    t.index ["customer_master_id"], name: "fk_rails_f60e80273e"
  end

  create_table "keisin_datas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "経審情報", force: :cascade do |t|
    t.integer "entity_id", comment: "エンティティID"
    t.string "sinsa_code", limit: 8, null: false, comment: "審査コード"
    t.string "sinsa_date", limit: 10, null: false, comment: "審査日"
    t.string "org_comp_name", comment: "基企業名"
    t.string "comp_name", comment: "企業名"
    t.string "comp_kana", comment: "企業名カナ"
    t.string "tel", limit: 13, comment: "電話番号"
    t.string "daihyo_name", comment: "代表者"
    t.string "pref_code", limit: 2, comment: "都道府県コード"
    t.string "address", comment: "住所"
    t.string "rireki_gaku", comment: "履歴額"
    t.float "kotei_shisan", limit: 53, comment: "固定資産"
    t.float "ryudo_fusai", limit: 53, comment: "流動負債"
    t.float "kotei_fusai", limit: 53, comment: "固定負債"
    t.float "rieki_yojo", limit: 53, comment: "利益余剰金"
    t.float "jiko_shihon", limit: 53, comment: "自己資本"
    t.float "touki_soshihon", limit: 53, comment: "総資本(当期)"
    t.float "zenki_soshihon", limit: 53, comment: "総資本(前期)"
    t.float "uriagedaka", limit: 53, comment: "売上高"
    t.float "uriage_sorieki", limit: 53, comment: "売上総利益"
    t.float "keijo_rieki", limit: 53, comment: "経常利益"
    t.string "specific_status", limit: 1, null: false, comment: "特定状態"
    t.text "memo", comment: "メモ"
    t.date "acquired_date", null: false, comment: "取得日"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "IDX_KEISIN_ENT_ID"
    t.index ["sinsa_code"], name: "IDX_KEISIN_CS_ID"
  end

  create_table "kpi_activations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "活性化KPI", force: :cascade do |t|
    t.integer "phase_code", null: false, comment: "コンバージョン段階"
    t.date "signup", null: false, comment: "基準月"
    t.date "as_of_month", null: false, comment: "計測月"
    t.integer "metrics", default: 0, comment: "指標"
    t.integer "sub_metrics_1", comment: "サブ指標1"
    t.integer "sub_metrics_2", comment: "サブ指標2"
    t.integer "sub_metrics_3", comment: "サブ指標3"
    t.integer "sub_metrics_4", comment: "サブ指標4"
    t.integer "sub_metrics_5", comment: "サブ指標5"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "kr_accounting_clearings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "会計消込情報", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "kr_sale_id", null: false, comment: "売上ID"
    t.integer "kr_deposit_id", null: false, comment: "入金ID"
    t.integer "clearing_amount", null: false, comment: "消込額"
    t.boolean "delete_flag", default: false, comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["kr_deposit_id"], name: "FK_KR_CLN_DEPO"
    t.index ["kr_sale_id"], name: "FK_KR_CLN_SALE"
    t.index ["member_id"], name: "FK_KR_CLN_MEMBER"
  end

  create_table "kr_deposits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "入金情報", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "deposit_type", null: false, comment: "入金種別\t1：MNT、2：PS定期、3：PS追加課金、9：その他"
    t.string "target_year_month", limit: 6, null: false, comment: "対象年月"
    t.integer "payment_type_code", null: false, comment: "支払方法コード\t1：カード、2：振替、3：振込"
    t.integer "create_type", null: false, comment: "作成種別\t1：自動、2：手動"
    t.integer "out_side_type", comment: "外部種別\t1：PayJP"
    t.string "out_side_id", limit: 40, comment: "外部ID"
    t.integer "deposit_amount", null: false, comment: "入金額"
    t.date "deposit_date", null: false, comment: "入金日"
    t.integer "status", default: 0, null: false, comment: "状態\t0：未使用、1：一部使用、2：使用済"
    t.text "memo", comment: "メモ"
    t.boolean "delete_flag", default: false, comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "FK_KR_DEPO_MEMBER"
  end

  create_table "kr_sale_closes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "売上締め情報", force: :cascade do |t|
    t.string "target_year_month", limit: 6, null: false, comment: "対象年月"
    t.integer "count_mnt", null: false, comment: "MNT件数"
    t.integer "count_ps", null: false, comment: "PS件数"
    t.integer "count_ps_add", null: false, comment: "PS追加分件数"
    t.integer "count_else", null: false, comment: "その他件数"
    t.integer "summary_mnt", null: false, comment: "MNT売上額"
    t.integer "summary_ps", null: false, comment: "PS売上額"
    t.integer "summary_ps_add", null: false, comment: "PS追加分売上額"
    t.integer "summary_else", null: false, comment: "その他売上額"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "kr_sales", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "売上情報", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "sale_type", null: false, comment: "売上種別\t1：MNT、2：PS定期、3：PS追加課金、9：その他"
    t.string "plan_name", limit: 30, comment: "プラン名"
    t.string "target_year_month", limit: 6, null: false, comment: "対象年月"
    t.integer "payment_type_code", null: false, comment: "支払方法コード\t1：カード、2：振替、3：振込"
    t.integer "payment_unit_type_code", null: false, comment: "支払単位\t1：月、2：年"
    t.integer "create_type", null: false, comment: "作成種別\t1：自動、2：手動"
    t.integer "sale_amount", null: false, comment: "売上額"
    t.integer "ps_point_id", comment: "PSポイントID"
    t.date "sale_date", null: false, comment: "売上日"
    t.integer "status", default: 0, null: false, comment: "状態\t0：未入金、1：一部入金、2：入金済"
    t.text "memo", comment: "メモ"
    t.boolean "delete_flag", default: false, comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "FK_KR_SALES_MEMBER"
  end

  create_table "kr_sales_bases", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "売上基礎情報", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "sale_type", null: false, comment: "売上種別\t1：MNT、2：PS"
    t.string "plan_name", limit: 30, comment: "プラン名"
    t.string "start_year_month", limit: 6, null: false, comment: "開始年月"
    t.string "end_year_month", limit: 6, null: false, comment: "終了年月"
    t.integer "payment_type_code", null: false, comment: "支払方法コード\t1：カード、2：振替、3：振込"
    t.integer "payment_unit_type_code", null: false, comment: "支払単位\t1：月、2：年"
    t.integer "sale_amount", null: false, comment: "売上額"
    t.text "memo", comment: "メモ"
    t.boolean "delete_flag", default: false, comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "FK_KR_SLBASE_MEMBER"
  end

  create_table "leave_forms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "退会フォーム", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "plan_history_id", comment: "最終会員MNプラン履歴ID"
    t.integer "ps_plan_history_id", comment: "最終会員PSプラン履歴ID"
    t.string "question1", comment: "質問1"
    t.string "question2", comment: "質問2"
    t.string "question3", comment: "質問3"
    t.string "question4", comment: "質問4"
    t.string "question5", comment: "質問5"
    t.string "question6", comment: "質問6"
    t.string "question7", comment: "質問7"
    t.string "question8", comment: "質問8"
    t.string "question9", comment: "質問9"
    t.string "question10", comment: "質問10"
    t.string "question11", comment: "質問11"
    t.string "question12", comment: "質問12"
    t.string "question13", comment: "13番目の質問項目"
    t.string "answer1", comment: "回答1"
    t.string "answer2", comment: "回答2"
    t.string "answer3", comment: "回答3"
    t.string "answer4", comment: "回答4"
    t.string "answer5", comment: "回答5"
    t.string "answer6", comment: "回答6"
    t.string "answer7", comment: "回答7"
    t.string "answer8", comment: "回答8"
    t.string "answer9", comment: "回答9"
    t.string "answer10", comment: "回答10"
    t.string "answer11", comment: "回答11"
    t.string "answer12", comment: "回答12"
    t.string "answer13", comment: "13番目の回答項目"
    t.boolean "ignore_flag", default: false, comment: "除外フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "member_id"
  end

  create_table "lighthouse_candidates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "Lighthouseの企業マスタ候補", force: :cascade do |t|
    t.integer "lighthouse_master_id", null: false, comment: "LighthouseマスタID"
    t.string "lighthouse_id", null: false, comment: "LighthouseID"
    t.string "name", null: false, comment: "企業名"
    t.string "address", comment: "本社住所"
    t.string "category", comment: "業界"
    t.string "url", comment: "URL"
    t.integer "status", default: 0, null: false, comment: "状態"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["lighthouse_master_id"], name: "lighthouse_master_id"
  end

  create_table "lighthouse_masters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "Lighthouseの企業マスタ", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスタID"
    t.string "lighthouse_id", comment: "LighthouseID"
    t.integer "reputation_count", default: 0, comment: "口コミ数"
    t.datetime "last_crawled_at", comment: "最後にクロールした日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id"], name: "customer_master_id"
  end

  create_table "mail_templates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "メールテンプレート", force: :cascade do |t|
    t.string "category", limit: 2, comment: "カテゴリー"
    t.string "title", comment: "title"
    t.text "content", comment: "本文"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "member_monthly_totals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "会員月次集計情報", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.datetime "target_month", null: false, comment: "対象年月"
    t.integer "alarm_customer_count", comment: "アラーム取引先設定件数"
    t.integer "now_plan_code", comment: "現プランコード"
    t.integer "alarm_count", comment: "アラーム回数"
    t.integer "alarm_lv1_count", comment: "アラームLV1回数"
    t.integer "alarm_lv2_count", comment: "アラームLV2回数"
    t.integer "alarm_lv3_count", comment: "アラームLV3回数"
    t.integer "credit_change_count", comment: "信用状況更新回数"
    t.boolean "send_flag", default: false, null: false, comment: "送信フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "members", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "会員情報", force: :cascade do |t|
    t.string "member_name", comment: "会員名"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.string "address", comment: "住所"
    t.string "tanto_name", comment: "担当者名"
    t.string "tanto_tel", comment: "担当先電話番号"
    t.integer "industry_type_code", comment: "業種種別コード"
    t.integer "customer_count_type_code", comment: "customer_count_type_code"
    t.string "zip_code", comment: "郵便番号"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.integer "annual_business_code", comment: "年商"
    t.integer "baitai_code", comment: "媒体コード"
    t.integer "syoukai_code", comment: "紹介コード"
    t.integer "existing_customers_num", comment: "既存取引先数　0:0～5社、1:6～50社、2:51～500社、3:501社～5000社、4:5001社以上、5:不明"
    t.integer "new_customers_num", comment: "新規取引先数　0:0～2社、1:3～10社、2:11～30社、3:31社～100社、4:101社以上、5:不明"
    t.string "department", comment: "部門"
    t.boolean "sales_suspend_flag", default: false, null: false, comment: "セールス抑止フラグ"
    t.boolean "available_flag", default: true, null: false, comment: "有効フラグ"
    t.string "mnt_status", limit: 1, comment: "モニタリング利用状態\t0:未利用、1:利用中、2:お試し、3:停止"
    t.date "mst_start_date", comment: "MNT利用開始日"
    t.string "ps_status", limit: 1, comment: "PS利用状態\t0:未利用、1:利用中、2:お試し、3:停止"
    t.date "ps_start_date", comment: "PS利用開始日"
    t.integer "maximum_user_cnt", default: 0, comment: "最大ユーザー数"
    t.integer "swap_rev_cnt", comment: "入替枠補正数"
    t.integer "member_category_code", default: 1, comment: "会員カテゴリコード"
    t.string "ricoh_mng_no", limit: 10, comment: "リコー口振管理番号"
    t.datetime "membership_fee_start_date", comment: "請求データ(利用開始日)"
    t.datetime "membership_fee_payment_date", comment: "請求データ(支払日)"
    t.datetime "membership_fee_expiration_date", comment: "請求データ(年払い有効日)"
    t.text "memo", comment: "メモ"
    t.text "call_memo", comment: "架電メモ"
    t.boolean "first_support_send_flag", default: false, comment: "初回取引先設定完了メール送信フラグ"
    t.boolean "ps_first_support_send_flag", default: false, comment: "PS初回サポートメール送信フラグ"
    t.integer "follow_priority", comment: "フォローアップ重要度"
    t.integer "v1_employee_id", comment: "社員ID"
  end

  create_table "monthly_mails", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "月次メール情報", force: :cascade do |t|
    t.datetime "mail_month", null: false, comment: "メール年月"
    t.datetime "task_total_date", comment: "集計日"
    t.datetime "delivery_date", comment: "配信日"
    t.string "title_1", comment: "タイトル１"
    t.text "url_1", comment: "URL１"
    t.text "snippet_1", comment: "スニペット１"
    t.string "image_1", comment: "イメージ１"
    t.string "title_2", comment: "タイトル２"
    t.text "url_2", comment: "URL２"
    t.text "snippet_2", comment: "スニペット２"
    t.string "image_2", comment: "イメージ２"
    t.boolean "task_total_flag", default: false, comment: "集計完了フラグ"
    t.boolean "all_send_flag", default: false, null: false, comment: "送信フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "notifications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "お知らせ", force: :cascade do |t|
    t.string "title", limit: 40, null: false, comment: "タイトル"
    t.text "content", null: false, comment: "内容"
    t.integer "target_type", null: false, comment: "対象種別\t1:全て, 2:モニタリング, 3:パワーサーチ"
    t.datetime "start_date", null: false, comment: "表示開始日時"
    t.datetime "end_date", null: false, comment: "表示終了日時"
    t.integer "output_type", null: false, comment: "出力タイプ\t1:通常, 2:HTML"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["id", "start_date"], name: "IDX_NOTIFICATION"
  end

  create_table "oauth_access_grants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "fk_rails_330c32d8d9"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "out_sb_requests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "外部ＳＢ審査要求情報", force: :cascade do |t|
    t.integer "entity_id", comment: "エンティティID"
    t.integer "outside_type", null: false, comment: "外部種別\t1:ラクスル"
    t.string "client_code", limit: 11, comment: "クライアントコード"
    t.string "outside_id", limit: 20, null: false, comment: "外部ID"
    t.string "corporate_name", limit: 200, null: false, comment: "法人名"
    t.string "zip_code", limit: 7, comment: "郵便番号"
    t.string "pref_name", limit: 4, comment: "都道府県名"
    t.integer "pref_code", comment: "都道府県コード"
    t.string "address", comment: "住所"
    t.string "daihyo", limit: 50, comment: "代表者名"
    t.string "tel", limit: 11, comment: "電話番号"
    t.string "corporation_url", comment: "URL"
    t.string "inp_corp_number", limit: 13, comment: "法人番号(入力値)"
    t.integer "urgency", comment: "緊急度\t1:通常、2:急ぎ、3:緊急"
    t.integer "convertible", comment: "換金性\t1:通常、2:換金性あり"
    t.string "product", comment: "商品"
    t.integer "desired_amount", comment: "希望額"
    t.integer "credit_limit", comment: "与信額"
    t.datetime "requested_at", comment: "依頼日時"
    t.datetime "responsed_at", comment: "応答日時"
    t.string "status", limit: 1, null: false, comment: "状態\t0:法人未特定、1:特定完了、2:自動審査中、3:審査未実施、4:審査中、5:審査完了、6:確認完了、7:通知完了、H:保留"
    t.string "specific_status", limit: 1, null: false, comment: "特定状態\t0:候補未取得、1:特定準備完了、8:自動確定、9:確定"
    t.string "result", limit: 1, null: false, comment: "審査結果\t1:審査OK、2:審査NG、3:審査中"
    t.string "reason", limit: 50, comment: "審査結果理由"
    t.integer "chk_employee_id", comment: "審査社員ID"
    t.integer "conf_employee_id", comment: "確認社員ID"
    t.string "memo", comment: "メモ"
    t.text "ab_memo", comment: "AB連絡内容"
    t.string "doc_path", comment: "資料パス"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "IDX_OSR_ENT_ID"
    t.index ["outside_type", "outside_id"], name: "IDX_OSR_OUT_ID"
  end

  create_table "out_site_evals", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "外部サイト評価情報", force: :cascade do |t|
    t.integer "customer_id", comment: "取引先ID"
    t.integer "purchase_id", comment: "企業購入情報ID"
    t.integer "outside_type", null: false, comment: "外部サイト種別"
    t.integer "hit_cnt", comment: "ヒット数"
    t.integer "match_hit_cnt", comment: "完全一致ヒット数"
    t.boolean "point_flag", comment: "ポイント有無"
    t.string "point", limit: 10, comment: "ポイント"
    t.string "daihyo", comment: "代表者"
    t.text "target_url", comment: "対象URL"
    t.text "company_url", comment: "会社URL"
    t.string "site_info", comment: "サイト情報"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_id"], name: "IDX_OSE_CST_ID"
    t.index ["purchase_id"], name: "IDX_OSE_PUR_ID"
  end

  create_table "outside_api_calls", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "外部api連携用テーブル", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.string "tanto_name", null: false, comment: "ご担当者名"
    t.string "company_name", null: false, comment: "会社名"
    t.string "tel", comment: "電話番号"
    t.string "email", null: false, comment: "メール"
    t.integer "new_customers_num", comment: "新規取引先数\t1桁のコードが保存される"
    t.integer "existing_customers_num", comment: "既存取引先数\t1桁のコードが保存される"
    t.integer "process_type", null: false, comment: "処理タイプ\t1:資料請求,2:会員登録"
    t.integer "regist_type", comment: "会員登録タイプ\t1:ps,2:mn"
    t.boolean "check_flag", default: false, null: false, comment: "チェックフラグ\ttrue:処理済み,\tfalse:未処理"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "payment_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "支払履歴", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.integer "payment_type_code", comment: "支払方法コード"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.datetime "start_date", null: false, comment: "開始日"
    t.datetime "end_date", comment: "終了日"
    t.integer "payment_unit_type_code", default: 1, null: false, comment: "支払単位"
    t.index ["member_id"], name: "fk_rails_22ad00d93e"
  end

  create_table "payment_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "支払方法", force: :cascade do |t|
    t.string "payment_name", comment: "支払方法名称"
  end

  create_table "plan_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "会員プラン履歴", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.integer "plan_type_code", comment: "プラン種別コード"
    t.integer "max_customer_register", default: 1, null: false, comment: "取引先最大登録件数"
    t.datetime "start_date", null: false, comment: "開始日"
    t.datetime "end_date", comment: "終了日"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "fk_rails_b4d711bb69"
    t.index ["plan_type_code", "end_date"], name: "index_plan_histories_type_end"
  end

  create_table "ps_browse_logs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PS閲覧記録", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "user_id", null: false, comment: "ユーザーID"
    t.integer "entity_id", null: false, comment: "エンティティID"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.index ["member_id"], name: "FK_PS_BRS_LOG_MEMBER"
    t.index ["user_id"], name: "FK_PS_BRS_LOG_USER"
  end

  create_table "ps_entity_finances", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "法人財務情報", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "法人ID"
    t.integer "source_type", null: false, comment: "情報源タイプ\t0:手入力、1:四季報、2:官報、3:経審"
    t.integer "source_id", null: false, comment: "情報源ID"
    t.string "target_month", limit: 6, null: false, comment: "対象年月YYYYMM"
    t.string "currency_code", limit: 3, comment: "通貨"
    t.string "item1", comment: "勘定科目1（売上高）"
    t.string "item2", comment: "勘定科目2（当期純利益）"
    t.string "item3", comment: "勘定科目3（総資産）"
    t.string "item4", comment: "勘定科目4（純資産）"
    t.string "item5", comment: "勘定科目5"
    t.string "item6", comment: "勘定科目6"
    t.bigint "value1", comment: "値1"
    t.bigint "value2", comment: "値2"
    t.bigint "value3", comment: "値3"
    t.bigint "value4", comment: "値4"
    t.bigint "value5", comment: "値5"
    t.bigint "value6", comment: "値6"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "ps_payment_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PS支払履歴", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "payment_type_code", null: false, comment: "支払方法コード\t1:クレカ、2:振替、3:振込"
    t.integer "payment_unit_type_code", null: false, comment: "支払単位コード\t1:月払い、2:年払い"
    t.datetime "start_date", null: false, comment: "開始日時"
    t.datetime "end_date", comment: "終了日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "FK_PS_PYHS_MEMEBER"
  end

  create_table "ps_plan_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PSプラン履歴", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "ps_plan_type_code", comment: "プラン種別コード\t0:お試し、1:本利用"
    t.datetime "start_date", null: false, comment: "開始日時"
    t.datetime "end_date", comment: "終了日時"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "FK_PS_PLHS_MEMEBER"
  end

  create_table "ps_plan_reservations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PSプラン変更予約", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "user_id", null: false, comment: "ユーザーID"
    t.boolean "check_flag", default: false, null: false, comment: "処理フラグ"
    t.integer "ps_plan_type_code", null: false, comment: "プラン種別コード\t2:ライト,\t3:ビジネス,\t4:カスタマイズ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "member_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "ps_points", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PSポイント", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "point_type", null: false, comment: "種別\t1:月次、2：追加購入、3:初回分、4:その他"
    t.integer "point", null: false, comment: "ポイント"
    t.integer "available_point", null: false, comment: "利用可能ポイント"
    t.date "purchase_date", null: false, comment: "購入日"
    t.date "expiration_date", null: false, comment: "有効期限"
    t.boolean "available_flag", null: false, comment: "有効フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id", "available_flag", "expiration_date"], name: "IDX_PS_PTS"
  end

  create_table "ps_purchase_social_check_usage_points", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PS反社チェック購入とPS利用明細の紐付け", force: :cascade do |t|
    t.integer "purchase_social_check_id", null: false, comment: "反社チェック購入ID"
    t.integer "usage_point_id", null: false, comment: "PS利用明細ID"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["purchase_social_check_id"], name: "purchase_social_check_id"
    t.index ["usage_point_id"], name: "usage_point_id"
  end

  create_table "ps_purchase_social_checks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PS反社チェックオプション購入", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "ユーザーID"
    t.integer "entity_id", null: false, comment: "法人ID"
    t.integer "status", default: 0, null: false, comment: "状態 0:未着手 1:調査中 2:完了"
    t.boolean "check_corporation", default: false, null: false, comment: "法人名で反社チェックするか"
    t.date "purchase_date", null: false, comment: "購入日"
    t.date "expiration_date", null: false, comment: "有効期限"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "entity_id"
    t.index ["user_id"], name: "user_id"
  end

  create_table "ps_social_check_target_persons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PS反社チェックターゲット人物", force: :cascade do |t|
    t.integer "purchase_social_check_id", null: false, comment: "反社チェック購入ID"
    t.string "name", null: false, comment: "名前"
    t.integer "position", null: false, comment: "関係性 0:代表取締役 1:取締役 2:株主 3:従業員 99:その他"
    t.string "position_other_title", comment: "関係性その他の名称"
    t.integer "gender", comment: "性別"
    t.integer "age", comment: "年齢"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["purchase_social_check_id"], name: "purchase_social_check_id"
  end

  create_table "ps_survey_requests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PS法人調査依頼", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "user_id", null: false, comment: "ユーザーID"
    t.boolean "check_flag", default: false, null: false, comment: "処理フラグ"
    t.boolean "keep_flag", default: false, comment: "保留フラグ"
    t.string "ps_usage_point_id", limit: 20, null: false, comment: "ポイント利用履歴ID"
    t.string "company_name", null: false, comment: "会社名"
    t.integer "prefecture_code", null: false, comment: "都道府県コード"
    t.string "address", null: false, comment: "住所"
    t.string "daihyo_name", comment: "代表者名"
    t.string "tel", comment: "電話番号"
    t.string "url", comment: "URL"
    t.integer "deal_rlt_code", null: false, comment: "取引関係コード"
    t.string "setting_reason_code", limit: 20, null: false, comment: "購入理由コード"
    t.text "setting_reason_text", comment: "設定理由のコメント"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "ps_test_members", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PSテスト会員", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
  end

  create_table "ps_tmp_finances", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "一時法人財務情報", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "法人ID"
    t.integer "purchase_id", null: false, comment: "企業購入ID"
    t.integer "source_type", null: false, comment: "情報源タイプ\t0:手入力、1:四季報、2:官報、3:経審"
    t.integer "source_id", null: false, comment: "情報源ID"
    t.string "target_month", limit: 6, null: false, comment: "対象年月YYYYMM"
    t.string "currency_code", limit: 3, comment: "通貨"
    t.string "item1", comment: "勘定科目1（売上高）"
    t.string "item2", comment: "勘定科目2（当期純利益）"
    t.string "item3", comment: "勘定科目3（総資産）"
    t.string "item4", comment: "勘定科目4（純資産）"
    t.string "item5", comment: "勘定科目5"
    t.string "item6", comment: "勘定科目6"
    t.bigint "value1", comment: "値1"
    t.bigint "value2", comment: "値2"
    t.bigint "value3", comment: "値3"
    t.bigint "value4", comment: "値4"
    t.bigint "value5", comment: "値5"
    t.bigint "value6", comment: "値6"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "ps_usage_points", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "PS利用明細", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "point_id", null: false, comment: "ポイントID"
    t.integer "purchase_id", null: false, comment: "企業購入情報ID"
    t.integer "usage_point", null: false, comment: "使用ポイント"
    t.integer "usage_type", null: false, comment: "種別 1:情報購入 2:調査依頼 3: 失効 4: 反社チェック購入"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "FK_PS_USAGE_MEMEBER"
    t.index ["point_id"], name: "FK_PS_USAGE_POINT"
    t.index ["purchase_id"], name: "FK_PS_USAGE_PURCHASE"
  end

  create_table "purchases", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "企業購入情報", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "entity_id", null: false, comment: "エンティティID"
    t.boolean "examination_order_flag", default: false, comment: "審査依頼フラグ"
    t.date "purchase_date", null: false, comment: "購入日"
    t.date "examination_order_date", comment: "審査依頼日"
    t.date "examination_done_date", comment: "審査完了日"
    t.date "expiration_date", null: false, comment: "有効期限"
    t.integer "customer_master_id", comment: "取引先マスタID"
    t.string "status", limit: 1, default: "0", comment: "状態"
    t.integer "deal_rlt_code", comment: "取引関係コード\t1:有、2:無、9:その他"
    t.string "setting_reason_code", limit: 20, comment: "購入理由コード\t1:取引継続・拡大、2:支払未入金、3:業界不評、4:取引開始検討、9:その他"
    t.text "setting_reason_text", comment: "設定理由コメント"
    t.string "disp_status", limit: 1, null: false, comment: "表示状態\t1:調査中、2：調査完了、3:閲覧可能"
    t.string "memo", limit: 2000, comment: "メモ"
    t.integer "cont_employee_id", comment: "調査請負社員ID"
    t.integer "chk_employee_id", comment: "審査社員ID"
    t.integer "conf_employee_id", comment: "確認社員ID"
    t.boolean "delete_flag", default: false, comment: "削除フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "relational_alarm_candidates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "関連会社アラーム情報の候補", force: :cascade do |t|
    t.integer "alarm_candidate_id", comment: "アラーム候補ID"
    t.string "crawler_table_name", limit: 127, null: false, comment: "テーブル名"
    t.integer "crawler_record_id", null: false, comment: "元データのID"
    t.integer "judge_id", comment: "処理した人のID"
    t.integer "reviewer_judge_id", comment: "アラーム候補の承認・破棄した人のID"
    t.integer "alarm_id", comment: "アラーム送信した場合のアラームID"
    t.integer "candidate_status", default: 0, comment: "アラーム候補が承認されたかどうか"
    t.integer "customer_master_id", null: false, comment: "取引先マスターID"
    t.integer "alarm_level", comment: "アラームレベル"
    t.string "alarm_source_code", limit: 4, comment: "アラームソースコード"
    t.string "detail_code_1", limit: 4, comment: "内容コード１"
    t.string "detail_code_2", limit: 4, comment: "内容コード２"
    t.text "link", comment: "リンク"
    t.datetime "alarm_date", comment: "アラーム日時"
    t.string "announce_info", limit: 1000, comment: "告知内容"
    t.string "memo", limit: 2000, comment: "メモ"
    t.string "close_cause", comment: "登記記録の閉鎖等の理由"
    t.boolean "send_alarm_flag", null: false, comment: "送信するか否か"
    t.boolean "is_main", null: false, comment: "主となる企業か否か"
    t.boolean "is_relational", null: false, comment: "関連会社フラグ"
    t.boolean "is_same_represent", null: false, comment: "代表者同一フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["alarm_candidate_id"], name: "alarm_candidate_id"
    t.index ["customer_master_id"], name: "fk_rel_alarm_candidate_customer_master_id"
  end

  create_table "rpa_exam_results", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "RPA調査結果", force: :cascade do |t|
    t.integer "customer_id", null: false, comment: "取引先ID"
    t.integer "site_type", null: false, comment: "サイト種別\t1:エンライトハウス、2:xxxx"
    t.text "url", null: false, comment: "URL"
    t.string "css_selector", limit: 2000, null: false, comment: "SW用CSSセレクタ"
    t.boolean "priority_flag", default: false, comment: "優先フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_id"], name: "FK_RPA_RESULT_CUSTOMER"
  end

  create_table "rpa_exam_targets", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "RPA調査対象", force: :cascade do |t|
    t.integer "customer_id", null: false, comment: "取引先ID"
    t.string "house_company_code", comment: "内部企業コード"
    t.string "corporation_number", comment: "法人番号"
    t.string "corporation_name", null: false, comment: "法人名"
    t.string "address", comment: "住所"
    t.integer "status", comment: "状態\t0:未処理、1:処理中、2:完了、9:エラー"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_id"], name: "FK_RPA_TARGET_CUSTOMER"
  end

  create_table "salesforce_syncs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "外部連携アラームテーブル", force: :cascade do |t|
    t.integer "customer_id", comment: "取引先ID"
    t.string "account_id", comment: "salesforce側の取引先テーブルID"
    t.integer "salesforce_user_id", comment: "salesforce_usersテーブルのID"
    t.string "customer_name", comment: "取引先名"
    t.string "daihyo_name", comment: "取引先代表者名"
    t.string "prefecture_string", comment: "都道府県名"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.string "address1", comment: "市区町村番地"
    t.integer "investigation_code", comment: "調査コード"
    t.integer "sync_code", comment: "同期コード"
    t.integer "processing_code", comment: "処理コード 1:設定 2:削除 3:社内同期"
    t.string "error_message", comment: "エラーメッセージ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "salesforce_users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "セールスフォースユーザー", force: :cascade do |t|
    t.integer "user_id", comment: "ユーザーID"
    t.integer "member_id", comment: "会員ID"
    t.string "connect_user_name", comment: "接続ユーザー名"
    t.string "connect_user_password", comment: "接続ユーザーパスワード"
    t.string "connect_security_token", comment: "接続ユーザーセキュリティトークン"
    t.string "oauth_client_id", comment: "OauthクライアントID"
    t.string "oauth_client_secret", comment: "Oauthクライアントシークレット"
    t.boolean "available_flag", default: true, null: false, comment: "有効フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "sb_agents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "SB代理店", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "法人ID"
    t.string "name", null: false, comment: "代理店名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sb_client_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "SBクライアントユーザー", force: :cascade do |t|
    t.bigint "sb_client_id", null: false, comment: "SBクライアントID"
    t.string "name", null: false, comment: "担当者名"
    t.string "name_kana", comment: "担当者名カナ"
    t.string "email", comment: "メールアドレス"
    t.string "department", comment: "部署"
    t.string "position", comment: "役職"
    t.string "contact_tel", comment: "希望連絡先"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sb_client_id"], name: "index_sb_client_users_on_sb_client_id"
  end

  create_table "sb_clients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "SBクライアント", force: :cascade do |t|
    t.integer "entity_id", comment: "法人ID"
    t.string "name", null: false, comment: "クライアント名"
    t.integer "status_id", comment: "ステータスID"
    t.string "taxagency_corporate_number", comment: "法人番号"
    t.integer "area_id", comment: "エリアID"
    t.integer "sb_tanto_id", comment: "SB担当者ID"
    t.string "daihyo_name", null: false, comment: "代表者名"
    t.string "zip_code", comment: "郵便番号"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.string "address", comment: "住所"
    t.string "tel", comment: "電話番号"
    t.string "industry_code", comment: "業種コード"
    t.string "industry_optional", comment: "業種(補足)"
    t.string "established_in", comment: "設立年月"
    t.integer "annual_sales", comment: "年商（千円）"
    t.integer "channel_id", comment: "媒体ID"
    t.bigint "sb_agent_id", comment: "SB代理店ID"
    t.boolean "anti_social", default: false, comment: "反社(反社の場合true)"
    t.text "content", comment: "内容"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "capital", comment: "資本金"
    t.index ["sb_agent_id"], name: "index_sb_clients_on_sb_agent_id"
  end

  create_table "screening_statuses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "審査期間", force: :cascade do |t|
    t.integer "status", comment: "状態"
  end

  create_table "seq_house_company_codes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", comment: "シーケンステーブル（内部企業コード作成用）", force: :cascade do |t|
  end

  create_table "shokuba_labo_mngs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "しょくばらぼ取込管理情報", force: :cascade do |t|
    t.datetime "imp_date", null: false, comment: "取込日時"
    t.integer "ins_count", null: false, comment: "登録件数"
    t.integer "upd_count", null: false, comment: "更新件数"
  end

  create_table "shokuba_labos", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "しょくばらぼ情報", force: :cascade do |t|
    t.integer "mng_id", null: false, comment: "取込管理番号"
    t.string "corporation_number", limit: 13, null: false, comment: "法人番号"
    t.integer "rev_no", null: false, comment: "改訂No"
    t.boolean "latest_flag", null: false, comment: "最新フラグ"
    t.string "company_name", limit: 150, null: false, comment: "企業名"
    t.string "url", limit: 512, comment: "ホームページURL"
    t.string "tel", limit: 30, comment: "電話番号"
    t.string "fax", limit: 14, comment: "FAX"
    t.string "founding_year", limit: 256, comment: "創業年"
    t.string "org_prefecture", limit: 13, comment: "加工前 都道府県"
    t.string "org_address", limit: 330, comment: "加工前 住所"
    t.string "org_daihyo_name", limit: 60, comment: "加工前 代表者"
    t.string "org_scale", limit: 7, comment: "加工前 企業規模"
    t.string "org_industry", limit: 514, comment: "加工前 業種"
    t.integer "gen_prefecture_code", comment: "加工 都道府県コード"
    t.string "gen_address", limit: 330, comment: "加工 住所"
    t.string "gen_daihyo_name", limit: 60, comment: "加工 代表者"
    t.integer "gen_emp_num", comment: "加工 従業員数"
    t.string "gen_industry", limit: 514, comment: "加工 業種"
    t.index ["corporation_number", "latest_flag"], name: "IDX_SLB_CORP_NO"
  end

  create_table "sikihou_datas", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "四季報情報", force: :cascade do |t|
    t.integer "entity_id", comment: "エンティティID"
    t.string "sikihou_number", limit: 10, comment: "四季報番号"
    t.integer "page", comment: "ページ数"
    t.string "category", limit: 50, comment: "業種"
    t.string "company_name", limit: 200, comment: "会社名"
    t.string "established", limit: 8, comment: "設立"
    t.string "closing_period", limit: 10, comment: "決算期"
    t.bigint "capital", comment: "資本金"
    t.string "employee_number", limit: 30, comment: "従業員"
    t.string "corporation_url", comment: "URL"
    t.string "daihyo_main", limit: 30, comment: "代表者名"
    t.string "daihyo_sub", comment: "役員"
    t.string "zip_code", limit: 7, comment: "郵便番号"
    t.string "pref_code", limit: 2, comment: "都道府県コード"
    t.string "address", comment: "住所"
    t.string "tel", limit: 11, comment: "電話番号"
    t.string "total_assets", comment: "総資産"
    t.string "financial_month", comment: "業績_年月"
    t.string "financial_info_1", comment: "業績_項目１"
    t.string "financial_info_2", comment: "業績_項目２"
    t.string "financial_info_3", comment: "業績_項目３"
    t.string "financial_info_4", comment: "業績_項目４"
    t.string "financial_info_5", comment: "業績_項目５"
    t.string "specific_status", limit: 1, null: false, comment: "特定状態"
    t.text "memo", comment: "メモ"
    t.date "acquired_date", null: false, comment: "取得日"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "IDX_SIKI_ENT_ID"
  end

  create_table "sikihou_finances", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "四季報財務情報", force: :cascade do |t|
    t.integer "sikihou_id", null: false, comment: "四季報ID"
    t.string "announce_month", limit: 6, null: false, comment: "告知年月"
    t.integer "desc_position", null: false, comment: "記載位置"
    t.string "type_name", limit: 10, null: false, comment: "財務種別"
    t.bigint "amount", null: false, comment: "金額"
    t.boolean "consolidate_flag", null: false, comment: "連結フラグ"
    t.boolean "interim_flag", null: false, comment: "中間フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["sikihou_id"], name: "IDX_SIKI_FNC_PRNT_ID"
  end

  create_table "site_watcher_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "サイトウォッチャー履歴", force: :cascade do |t|
    t.integer "site_watcher_id", null: false, comment: "サイトウォッチャーID"
    t.datetime "replacement_date", null: false, comment: "サイトの更新日時"
    t.integer "average_updated_time", comment: "サイト更新の平均日数"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["site_watcher_id"], name: "site_watcher_id"
  end

  create_table "site_watchers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "サイトウォッチャー情報", force: :cascade do |t|
    t.text "title", comment: "タイトル"
    t.text "url", comment: "URL"
    t.string "css_selector", limit: 2000, comment: "選択箇所"
    t.integer "index_num", comment: "階層"
    t.string "x_path", limit: 2000, comment: "XPath"
    t.text "sub_title", comment: "サブタイトル"
    t.text "company_name", comment: "企業名"
    t.boolean "read_flag", default: false, null: false, comment: "読込フラグ"
    t.boolean "check_flag", default: false, null: false, comment: "チェックフラグ"
    t.binary "before_html", limit: 16777215, comment: "チェック前HTML"
    t.binary "after_html", limit: 16777215, comment: "チェック後HTML"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.string "house_company_code", comment: "内部企業コード"
    t.integer "crawl_level", default: 1, null: false, comment: "クロールレベル"
    t.string "alarm_source_code", limit: 4, comment: "アラームソースコード"
    t.boolean "available_flag", default: true, comment: "有効フラグ"
    t.datetime "delay_check_time", comment: "遅延確認した日時"
    t.index ["check_flag"], name: "index_site_watchers_check_flag"
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "タグ", force: :cascade do |t|
    t.string "tag_code", limit: 4, null: false, comment: "タグコード"
    t.string "tag_name", comment: "タグ名"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["tag_code"], name: "tag_code", unique: true
  end

  create_table "tenshokukaigi_candidates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "転職会議の企業マスタ候補", force: :cascade do |t|
    t.integer "tenshokukaigi_master_id", null: false, comment: "転職会議マスタID"
    t.integer "tenshokukaigi_id", null: false, comment: "転職会議ID"
    t.string "name", null: false, comment: "企業名"
    t.string "address", comment: "本社住所"
    t.string "category", comment: "業界"
    t.string "url", comment: "URL"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["tenshokukaigi_master_id"], name: "tenshokukaigi_master_id"
  end

  create_table "tenshokukaigi_masters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "転職会議の企業マスタ", force: :cascade do |t|
    t.integer "customer_master_id", null: false, comment: "取引先マスタID"
    t.integer "tenshokukaigi_id", comment: "転職会議ID"
    t.integer "reputation_count", default: 0, comment: "評判数"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_master_id"], name: "customer_master_id"
  end

  create_table "test_site_watchers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "ID", force: :cascade do |t|
    t.text "title", comment: "タイトル"
    t.text "url", comment: "URL"
    t.string "css_selector", limit: 2000, comment: "選択箇所"
    t.integer "index_num", comment: "階層"
    t.text "sub_title", comment: "サブタイトル"
    t.text "company_name", comment: "企業名"
    t.boolean "read_flag", default: false, null: false, comment: "読込フラグ"
    t.boolean "check_flag", default: false, null: false, comment: "チェックフラグ"
    t.binary "before_html", limit: 16777215, comment: "チェック前HTML"
    t.binary "after_html", limit: 16777215, comment: "チェック後HTML"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.string "house_company_code", comment: "内部企業コード"
    t.integer "crawl_level", default: 1, null: false, comment: "クロールレベル"
    t.boolean "available_flag", default: true, comment: "有効フラグ"
  end

  create_table "tmp_alarms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "アラーム一時情報", force: :cascade do |t|
    t.integer "customer_id", comment: "取引先ID"
    t.integer "purchase_id", comment: "企業購入情報ID"
    t.integer "disp_order", null: false, comment: "表示順"
    t.integer "alarm_level", comment: "アラームレベル"
    t.string "alarm_source_code", limit: 4, comment: "アラームソースコード"
    t.string "detail_code_1", limit: 4, comment: "内容コード１"
    t.string "detail_code_2", limit: 4, comment: "内容コード２"
    t.text "research", comment: "調査内容"
    t.datetime "alarm_date", comment: "アラーム日時"
    t.string "announce_info", limit: 1000, comment: "告知内容"
    t.text "link", comment: "リンク"
    t.string "doc_path", comment: "資料パス"
    t.string "confirm_code", limit: 1, comment: "確認コード"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_id", "disp_order"], name: "IDX_TMP_ALM_CST_ID"
    t.index ["purchase_id", "disp_order"], name: "IDX_TMP_ALM_PUR_ID"
  end

  create_table "tmp_profiles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "一時法人概要", force: :cascade do |t|
    t.integer "entity_id", null: false, comment: "エンティティID"
    t.integer "purchase_id", null: false, comment: "企業購入情報ID"
    t.string "daihyo_name", comment: "代表者名"
    t.string "daihyo_tel", comment: "代表電話番号"
    t.string "employee_number", comment: "従業員数"
    t.bigint "capital", comment: "資本金"
    t.bigint "capital_range_min", comment: "資本金範囲最小"
    t.bigint "capital_range_max", comment: "資本金範囲最大"
    t.string "capital_comment", limit: 30, comment: "資本金補足文言"
    t.string "finance_comment", limit: 30, comment: "財務補足文言"
    t.string "finance_graph_comment", limit: 30, comment: "財務グラフコメント"
    t.string "corporation_url", comment: "コーポレートサイト"
    t.string "social_insurance_code", limit: 1, comment: "社会保険加入フラグ"
    t.integer "payment_history", default: 0, null: false, comment: "支払履歴\t0:情報なし、1:正常な支払履歴（継続）、2:正常な支払履歴（過去）、3:懸念なし、4:やや懸念あり、5:懸念あり"
    t.text "anti_social_info", comment: "反社内容"
    t.text "ai_comment", comment: "AIコメント"
    t.text "human_comment", comment: "与信管理士コメント"
    t.string "main_tag_code", limit: 4, comment: "メインタグコード"
    t.string "finance_change_flag", limit: 1, comment: "財務変更フラグ\t0:変更なし、1:変更あり"
    t.string "established", comment: "設立日"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["entity_id"], name: "IDX_TPRF_ENTITY"
    t.index ["purchase_id"], name: "IDX_TPRF_PURCHASE"
  end

  create_table "tmp_specific_candidates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "企業候補一時情報", force: :cascade do |t|
    t.integer "customer_id", comment: "取引先ID"
    t.integer "purchase_id", comment: "企業購入情報ID"
    t.integer "entity_id", comment: "エンティティID"
    t.string "house_company_code", comment: "内部企業コード"
    t.string "corporation_number", comment: "法人番号"
    t.string "corporation_name", comment: "法人名"
    t.integer "prefecture_code", comment: "都道府県コード"
    t.string "address1", comment: "住所１"
    t.integer "accuracy", comment: "確度"
    t.string "tsr_corporation_name", comment: "TSR詳細情報有無"
    t.string "tsr_code", limit: 11, comment: "TSRコード"
    t.string "tsr_industry", comment: "TSR業界"
    t.string "tsr_daihyo_name", limit: 40, comment: "TSR代表者"
    t.string "tsr_update_info", limit: 50, comment: "TSR企業情報更新年月"
    t.string "tsr_score_flag", limit: 1, comment: "TSR評点有無"
    t.string "tsr_bankrupt_flag", limit: 1, comment: "TSR倒産情報有無"
    t.string "tsr_detail_flag", limit: 1, comment: "TSR詳細情報有無"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["customer_id"], name: "IDX_TSC_CST_ID"
    t.index ["purchase_id"], name: "IDX_TSC_PUR_ID"
  end

  create_table "tmp_specific_corporations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "企業特定一時情報", force: :cascade do |t|
    t.integer "customer_id", null: false, comment: "取引先ID"
    t.string "house_company_code", comment: "内部企業コード"
    t.string "corporation_number", comment: "法人番号"
    t.integer "candidate_id", comment: "候補ID"
    t.string "status", limit: 1, default: "0", comment: "状態"
    t.string "memo", comment: "メモ"
    t.boolean "sep_work_flag_1", default: false, comment: "分割作業フラグ1"
    t.boolean "sep_work_flag_2", default: false, comment: "分割作業フラグ2"
    t.boolean "sep_work_flag_3", default: false, comment: "分割作業フラグ3"
    t.boolean "sep_work_flag_4", default: false, comment: "分割作業フラグ4"
    t.boolean "sep_work_flag_5", default: false, comment: "分割作業フラグ5"
    t.boolean "sep_work_flag_6", default: false, comment: "分割作業フラグ6"
    t.boolean "sep_work_flag_7", default: false, comment: "分割作業フラグ7"
    t.boolean "sep_work_flag_8", default: false, comment: "分割作業フラグ8"
    t.boolean "sep_work_flag_9", default: false, comment: "分割作業フラグ9"
    t.boolean "sep_work_flag_10", default: false, comment: "分割作業フラグ10"
    t.boolean "sep_work_flag_11", default: false, comment: "分割作業フラグ11"
    t.boolean "sep_work_flag_12", default: false, comment: "分割作業フラグ12"
    t.boolean "sep_work_flag_13", default: false, comment: "分割作業フラグ13"
    t.boolean "sep_work_flag_14", default: false, comment: "分割作業フラグ14"
    t.boolean "sep_work_flag_15", default: false, comment: "分割作業フラグ15"
    t.boolean "sep_work_flag_16", default: false, comment: "分割作業フラグ16"
    t.boolean "sep_work_flag_17", default: false, comment: "分割作業フラグ17"
    t.boolean "sep_work_flag_18", default: false, comment: "分割作業フラグ18"
    t.boolean "sep_work_flag_19", default: false, comment: "分割作業フラグ19"
    t.boolean "sep_work_flag_20", default: false, comment: "分割作業フラグ20"
    t.integer "sep_work_emp_id_1", default: 0, comment: "分割作業ユーザー1"
    t.integer "sep_work_emp_id_2", default: 0, comment: "分割作業ユーザー2"
    t.integer "sep_work_emp_id_3", default: 0, comment: "分割作業ユーザー3"
    t.integer "sep_work_emp_id_4", default: 0, comment: "分割作業ユーザー4"
    t.integer "sep_work_emp_id_5", default: 0, comment: "分割作業ユーザー5"
    t.integer "sep_work_emp_id_6", default: 0, comment: "分割作業ユーザー6"
    t.integer "sep_work_emp_id_7", default: 0, comment: "分割作業ユーザー7"
    t.integer "sep_work_emp_id_8", default: 0, comment: "分割作業ユーザー8"
    t.integer "sep_work_emp_id_9", default: 0, comment: "分割作業ユーザー9"
    t.integer "sep_work_emp_id_10", default: 0, comment: "分割作業ユーザー10"
    t.integer "sep_work_emp_id_11", default: 0, comment: "分割作業ユーザー11"
    t.integer "sep_work_emp_id_12", default: 0, comment: "分割作業ユーザー12"
    t.integer "sep_work_emp_id_13", default: 0, comment: "分割作業ユーザー13"
    t.integer "sep_work_emp_id_14", default: 0, comment: "分割作業ユーザー14"
    t.integer "sep_work_emp_id_15", default: 0, comment: "分割作業ユーザー15"
    t.integer "sep_work_emp_id_16", default: 0, comment: "分割作業ユーザー16"
    t.integer "sep_work_emp_id_17", default: 0, comment: "分割作業ユーザー17"
    t.integer "sep_work_emp_id_18", default: 0, comment: "分割作業ユーザー18"
    t.integer "sep_work_emp_id_19", default: 0, comment: "分割作業ユーザー19"
    t.integer "sep_work_emp_id_20", default: 0, comment: "分割作業ユーザー20"
    t.integer "cont_employee_id", comment: "調査請負社員ID"
    t.integer "chk_employee_id", comment: "審査社員ID"
    t.integer "conf_employee_id", comment: "確認社員ID"
    t.integer "inp_employee_id", comment: "入力ユーザーID"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "trust_legal_entities", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "信頼法人格", force: :cascade do |t|
    t.string "legal_entity", limit: 200, null: false, comment: "法人格"
    t.boolean "trust_flag", default: false, comment: "信頼フラグ"
  end

  create_table "unsubscribe_forms", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "有料プラン解除フォーム", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "plan_history_id", null: false, comment: "最終会員プラン履歴ID"
    t.string "question1", comment: "質問1"
    t.string "question2", comment: "質問2"
    t.string "question3", comment: "質問3"
    t.string "question4", comment: "質問4"
    t.string "question5", comment: "質問5"
    t.string "question6", comment: "質問6"
    t.string "question7", comment: "質問7"
    t.string "question8", comment: "質問8"
    t.string "question9", comment: "質問9"
    t.string "question10", comment: "質問10"
    t.string "question11", comment: "質問11"
    t.string "question12", comment: "質問12"
    t.string "question13", comment: "13番目の質問項目"
    t.string "answer1", comment: "回答1"
    t.string "answer2", comment: "回答2"
    t.string "answer3", comment: "回答3"
    t.string "answer4", comment: "回答4"
    t.string "answer5", comment: "回答5"
    t.string "answer6", comment: "回答6"
    t.string "answer7", comment: "回答7"
    t.string "answer8", comment: "回答8"
    t.string "answer9", comment: "回答9"
    t.string "answer10", comment: "回答10"
    t.string "answer11", comment: "回答11"
    t.string "answer12", comment: "回答12"
    t.string "answer13", comment: "13番目の回答項目"
    t.boolean "ignore_flag", default: false, comment: "除外フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "member_id"
    t.index ["plan_history_id"], name: "plan_history_id"
  end

  create_table "user_receive_alarm_sources", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "ユーザー受信アラームソース", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "ユーザーID"
    t.string "word_code", limit: 4, null: false, comment: "ワードコード"
    t.integer "alarm_level", null: false, comment: "アラームレベル"
    t.integer "status", default: 1, null: false, comment: "受信ステータス"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["user_id", "word_code", "alarm_level"], name: "user_receive_alarm_sources_uk", unique: true
    t.index ["word_code"], name: "user_receive_alarm_sources_ibfk_2"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "ユーザー情報", force: :cascade do |t|
    t.string "email", default: "", null: false, comment: "Eメールアドレス"
    t.string "encrypted_password", default: "", null: false, comment: "暗号化パスワード"
    t.string "reset_password_token", comment: "リセットパスワードトークン"
    t.datetime "reset_password_sent_at", comment: "パスワードリセット日時"
    t.datetime "remember_created_at", comment: "devise用カラム"
    t.integer "sign_in_count", default: 0, null: false, comment: "接続回数"
    t.datetime "current_sign_in_at", comment: "最終ログイン日時"
    t.datetime "last_sign_in_at", comment: "前回ログイン日時"
    t.string "current_sign_in_ip", comment: "最終ログインIPアドレス"
    t.string "last_sign_in_ip", comment: "前回ログインIPアドレス"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.integer "member_id", comment: "会員ID"
    t.string "omniauth_provider", comment: "ソーシャル認証プロバイダー"
    t.string "omniauth_uid", comment: "ソーシャル認証ユーザーID"
    t.string "omniauth_token", comment: "ソーシャル認証トークン"
    t.boolean "available_flag", default: true, null: false, comment: "有効フラグ"
    t.integer "sine_in_type", comment: "サインインタイプ\t1:モニタリング、2:パワーサーチ"
    t.boolean "owner_flag", default: true, comment: "オーナーユーザー"
    t.boolean "support_send_flag", default: false, comment: "フォローメール送信フラグ"
    t.boolean "lead_to_ps_flag", default: true, comment: "MNからPSへの導線表示判定フラグ 0:非表示,1:表示"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "v1_employee_mails", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "メール", force: :cascade do |t|
    t.integer "member_id", null: false, comment: "会員ID"
    t.integer "v1_employee_id", null: false, comment: "社員ID"
    t.integer "mail_template_id", comment: "メールテンプレートID"
    t.string "type_code", limit: 2, comment: "種別"
    t.string "to", limit: 1023, comment: "To"
    t.string "cc", limit: 1023, comment: "Cc"
    t.string "bcc", limit: 1023, comment: "Bcc"
    t.string "from", comment: "From"
    t.string "title", comment: "title"
    t.text "content", comment: "本文"
    t.string "attachment", comment: "添付"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["member_id"], name: "mails_ibfk_1"
  end

  create_table "v1_employees", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "社員情報", force: :cascade do |t|
    t.string "email", default: "", null: false, comment: "Eメールアドレス"
    t.string "encrypted_password", default: "", null: false, comment: "暗号化パスワード"
    t.string "name", null: false, comment: "氏名"
    t.integer "authority_code", default: 0, comment: "権限コード"
    t.integer "dept_code", comment: "部署コード"
    t.string "message", limit: 1023, comment: "メッセージ"
    t.string "photo", comment: "フォト"
    t.string "reset_password_token", comment: "リセットパスワードトークン"
    t.datetime "reset_password_sent_at", comment: "パスワードリセット日時"
    t.datetime "remember_created_at", comment: "devise用カラム"
    t.integer "sign_in_count", default: 0, null: false, comment: "接続回数"
    t.datetime "current_sign_in_at", comment: "最終ログイン日時"
    t.datetime "last_sign_in_at", comment: "前回ログイン日時"
    t.string "current_sign_in_ip", comment: "最終ログインIPアドレス"
    t.string "last_sign_in_ip", comment: "前回ログインIPアドレス"
    t.boolean "available_flag", default: true, null: false, comment: "有効フラグ"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "withdraws", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "退会理由", force: :cascade do |t|
    t.integer "member_id", comment: "会員ID"
    t.string "reason", comment: "退会理由"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
  end

  create_table "word_category_masters", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC", comment: "文言カテゴリマスター", force: :cascade do |t|
    t.integer "category_type", null: false, comment: "カテゴリ種別"
    t.integer "disp_order", null: false, comment: "表示順"
    t.string "word_code", limit: 4, comment: "コード"
    t.string "word", comment: "文言"
    t.datetime "created_at", null: false, comment: "登録日時"
    t.datetime "updated_at", null: false, comment: "更新日時"
    t.index ["word_code"], name: "IDX_WCM_CODE"
  end

  add_foreign_key "ab_alarm_mail_settings", "users", name: "fk_abms_user_id"
  add_foreign_key "ab_alarm_monthly_totals", "customer_masters", name: "ab_alarm_monthly_totals_ibfk_1"
  add_foreign_key "ab_alarm_totals", "customer_masters", name: "ab_alarm_totals_ibfk_1"
  add_foreign_key "ab_credit_mail_lists", "credits", column: "after_credit_id", name: "FK_ACML_ACID"
  add_foreign_key "ab_credit_mail_lists", "credits", column: "before_credit_id", name: "FK_ACML_BCID"
  add_foreign_key "ab_credit_mail_lists", "customer_masters", name: "FK_ACML_CMID"
  add_foreign_key "ab_credit_mail_lists", "members", name: "FK_ACML_MID"
  add_foreign_key "ab_customer_memo_histories", "customers", name: "ab_customer_memo_histories_ibfk_1"
  add_foreign_key "ab_selectbox_value_lists", "users", name: "ab_selectbox_value_lists_ibfk_1"
  add_foreign_key "accounting_kanpou_items", "accounting_kanpou_roots", name: "FK_AKI_ROOT"
  add_foreign_key "accounting_kanpou_roots", "entities", name: "FK_AKR_ENTITY"
  add_foreign_key "alarm_candidates", "customer_masters", name: "fk_alarm_candidate_customer_master_id"
  add_foreign_key "alarm_candidates", "judges", name: "fk_alarm_candidate_judge_id"
  add_foreign_key "alarm_prtimes", "crawl_prtimes_check_lists", name: "alarm_prtimes_ibfk_1"
  add_foreign_key "alarms", "customer_masters"
  add_foreign_key "alliance_members", "members", name: "alliance_members_ibfk_1"
  add_foreign_key "by_agents", "employees", name: "FK_BY_AGT_EMPLOYEE"
  add_foreign_key "by_customers", "employees", name: "FK_BY_CST_EMPLOYEE"
  add_foreign_key "by_customers", "entities", name: "FK_BY_CST_ENTITY"
  add_foreign_key "by_examinations", "by_customers", name: "FK_BY_EXM_CUSTOMER"
  add_foreign_key "by_examinations", "employees", name: "FK_BY_EXM_EMPLOYEE"
  add_foreign_key "by_guarantees", "by_things", name: "FK_BY_GRT_THING"
  add_foreign_key "by_guarantees", "employees", name: "FK_BY_GRT_EMPLOYEE"
  add_foreign_key "by_things", "by_agents", name: "FK_BY_THN_AGENT"
  add_foreign_key "by_things", "by_customers", name: "FK_BY_THN_CUSTOMER"
  add_foreign_key "by_things", "employees", name: "FK_BY_THN_EMPLOYEE"
  add_foreign_key "card_masters", "members"
  add_foreign_key "cards", "card_masters"
  add_foreign_key "code_prtimes", "crawl_prtimes_check_lists", name: "code_prtimes_ibfk_1"
  add_foreign_key "corporation_watchers", "customer_masters", name: "corporation_watchers_ibfk_2"
  add_foreign_key "corporation_watchers", "entities", name: "corporation_watchers_ibfk_1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "crawl_google_check_lists", "customer_masters"
  add_foreign_key "crawl_google_difference_lists", "customer_masters"
  add_foreign_key "crawl_lighthouse_check_lists", "customer_masters", name: "crawl_lighthouse_check_lists_ibfk_1"
  add_foreign_key "crawl_nikkei_check_lists", "customer_masters", name: "crawl_nikkei_check_lists_ibfk_1"
  add_foreign_key "crawl_prtimes_check_lists", "customer_masters", name: "crawl_prtimes_check_lists_ibfk_1"
  add_foreign_key "crawl_tdnet_check_lists", "customer_masters", name: "fk_customer_master"
  add_foreign_key "crawl_tenshokukaigi_check_lists", "customer_masters", name: "crawl_tenshokukaigi_check_lists_ibfk_1"
  add_foreign_key "crawl_twitter_check_lists", "customer_masters"
  add_foreign_key "credits", "customer_masters"
  add_foreign_key "crm_kairos_lead_infos", "employees", name: "FK_KAIROS_LEAD_EMPLOYEE"
  add_foreign_key "crm_kairos_lead_infos", "members", name: "FK_KAIROS_LEAD_MEMBER"
  add_foreign_key "crm_member_lead_infos", "employees", name: "FK_MEMBER_LEAD_EMPLOYEE"
  add_foreign_key "crm_member_lead_infos", "members", name: "FK_MEMBER_LEAD_MEMBER"
  add_foreign_key "customer_master_histories", "customer_masters", name: "customer_master_histories_ibfk_1"
  add_foreign_key "customer_registration_counts", "customer_masters"
  add_foreign_key "customers", "members"
  add_foreign_key "dialogs", "judges", column: "v1_employee_id", name: "dialogs_ibfk_2"
  add_foreign_key "dialogs", "members", name: "dialogs_ibfk_1"
  add_foreign_key "entity_profiles", "entities", name: "entity_profiles_ibfk_1"
  add_foreign_key "entity_relations", "entities", column: "relation_entity_id", name: "entity_relations_ibfk_2"
  add_foreign_key "entity_relations", "entities", name: "entity_relations_ibfk_1"
  add_foreign_key "entity_tags", "entities", name: "entity_tags_ibfk_1"
  add_foreign_key "entity_tags", "tags", column: "tag_code", primary_key: "tag_code", name: "entity_tags_ibfk_2"
  add_foreign_key "exam_details", "entities", name: "FK_EXD_ENTITY"
  add_foreign_key "exclude_entities", "entities", name: "exclude_entities_ibfk_1"
  add_foreign_key "grabs", "customer_masters", name: "grabs_ibfk_2"
  add_foreign_key "grabs", "judges", name: "grabs_ibfk_1"
  add_foreign_key "improvements", "members"
  add_foreign_key "internalonly_requests", "members", name: "internalonly_requests_ibfk_1"
  add_foreign_key "kanpou_posts", "customer_masters"
  add_foreign_key "kr_accounting_clearings", "kr_deposits", name: "FK_KR_CLN_DEPO"
  add_foreign_key "kr_accounting_clearings", "kr_sales", name: "FK_KR_CLN_SALE"
  add_foreign_key "kr_accounting_clearings", "members", name: "FK_KR_CLN_MEMBER"
  add_foreign_key "kr_deposits", "members", name: "FK_KR_DEPO_MEMBER"
  add_foreign_key "kr_sales", "members", name: "FK_KR_SALES_MEMBER"
  add_foreign_key "kr_sales_bases", "members", name: "FK_KR_SLBASE_MEMBER"
  add_foreign_key "leave_forms", "members", name: "leave_forms_ibfk_1"
  add_foreign_key "lighthouse_candidates", "lighthouse_masters", name: "lighthouse_candidates_ibfk_1"
  add_foreign_key "lighthouse_masters", "customer_masters", name: "lighthouse_masters_ibfk_1"
  add_foreign_key "payment_histories", "members"
  add_foreign_key "plan_histories", "members"
  add_foreign_key "ps_browse_logs", "members", name: "FK_PS_BRS_LOG_MEMBER"
  add_foreign_key "ps_browse_logs", "users", name: "FK_PS_BRS_LOG_USER"
  add_foreign_key "ps_payment_histories", "members", name: "FK_PS_PYHS_MEMEBER"
  add_foreign_key "ps_plan_histories", "members", name: "FK_PS_PLHS_MEMEBER"
  add_foreign_key "ps_plan_reservations", "members", name: "ps_plan_reservations_ibfk_1"
  add_foreign_key "ps_plan_reservations", "users", name: "ps_plan_reservations_ibfk_2"
  add_foreign_key "ps_points", "members", name: "FK_PS_PTS_MEMEBER"
  add_foreign_key "ps_purchase_social_check_usage_points", "ps_purchase_social_checks", column: "purchase_social_check_id", name: "ps_purchase_social_check_usage_points_ibfk_1"
  add_foreign_key "ps_purchase_social_check_usage_points", "ps_usage_points", column: "usage_point_id", name: "ps_purchase_social_check_usage_points_ibfk_2"
  add_foreign_key "ps_purchase_social_checks", "entities", name: "ps_purchase_social_checks_ibfk_2"
  add_foreign_key "ps_purchase_social_checks", "users", name: "ps_purchase_social_checks_ibfk_1"
  add_foreign_key "ps_social_check_target_persons", "ps_purchase_social_checks", column: "purchase_social_check_id", name: "ps_social_check_target_persons_ibfk_1"
  add_foreign_key "ps_usage_points", "members", name: "FK_PS_USAGE_MEMEBER"
  add_foreign_key "ps_usage_points", "ps_points", column: "point_id", name: "FK_PS_USAGE_POINT"
  add_foreign_key "relational_alarm_candidates", "customer_masters", name: "fk_rel_alarm_candidate_customer_master_id"
  add_foreign_key "rpa_exam_results", "customers", name: "FK_RPA_RESULT_CUSTOMER"
  add_foreign_key "rpa_exam_targets", "customers", name: "FK_RPA_TARGET_CUSTOMER"
  add_foreign_key "sb_client_users", "sb_clients"
  add_foreign_key "sb_clients", "sb_agents"
  add_foreign_key "site_watcher_histories", "site_watchers", name: "site_watcher_histories_ibfk_1"
  add_foreign_key "tenshokukaigi_candidates", "tenshokukaigi_masters", name: "tenshokukaigi_candidates_ibfk_1"
  add_foreign_key "tenshokukaigi_masters", "customer_masters", name: "tenshokukaigi_masters_ibfk_1"
  add_foreign_key "unsubscribe_forms", "members", name: "unsubscribe_forms_ibfk_1"
  add_foreign_key "unsubscribe_forms", "plan_histories", name: "unsubscribe_forms_ibfk_2"
  add_foreign_key "user_receive_alarm_sources", "users", name: "user_receive_alarm_sources_ibfk_1"
  add_foreign_key "user_receive_alarm_sources", "word_category_masters", column: "word_code", primary_key: "word_code", name: "user_receive_alarm_sources_ibfk_2"
  add_foreign_key "v1_employee_mails", "members", name: "mails_ibfk_1"
end
