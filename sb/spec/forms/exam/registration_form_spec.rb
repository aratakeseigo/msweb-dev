require "rails_helper"

RSpec.describe Exam::RegistrationForm, type: :model do
  let(:internal_user) { create :internal_user }
  let(:entity) { create :entity }
  let(:sb_client) { create :sb_client, entity: entity }
  let(:sb_guarantee_exam_request) { create :sb_guarantee_exam_request }
  let(:exam_form) { Exam::RegistrationForm.new(sb_client, internal_user, sb_guarantee_exam_request) }
  let(:client_hash) {
    {
      "cl_company_name" => "株式会社ヨントリー",
      "cl_daihyo_name" => "鳥居　太郎",
      "cl_taxagency_corporate_number" => "4445556667779",
      "cl_full_address" => "神奈川県川崎市高津区下野毛５－６－７",
      "cl_tel" => "0442679999",
    }
  }
  let(:customer_hash) {
    {
      "company_name" => "有限会社千本桜酒店",
      "daihyo_name" => "千本　桜",
      "taxagency_corporate_number" => "1234657980123",
      "full_address" => "神奈川県大和市福田４５００",
      "tel" => "0462679999",
    }
  }
  let(:exam_hash) {
    {
      "transaction_contents" => "取扱い商品", # 取扱い商品
      "payment_method_id" => PaymentMethod.all.sample, # 決済条件
      "payment_method_optional" => "決済条件補足", # 決済条件補足
      "new_transaction" => true, # 取引
      "transaction_years" => 3, # 取引歴
      "payment_delayed" => true, # 支払い遅延
      "payment_delayed_memo" => "支払い遅延の状況", # 支払い遅延の状況
      "payment_method_changed" => true, # 支払条件変更
      "payment_method_changed_memo" => "支払条件変更内容", # 支払条件変更内容
      "other_companies_ammount" => "ＡＢ蛇内保証会社", # 保証会社名
      "other_guarantee_companies" => 900000, # 保証額
      "guarantee_amount_hope" => 5000000, # 保証希望額
    }
  }

  let(:client_hash_2) {
    {
      "cl_company_name" => "株式会社ユウヒ",
      "cl_daihyo_name" => "朝日　太郎",
      "cl_taxagency_corporate_number" => "0005556667779",
      "cl_full_address" => "神奈川県川崎市高津区宮内５－６－７",
      "cl_tel" => "0942679999",
    }
  }
  let(:customer_hash_2) {
    {
      "company_name" => "有限会社代官",
      "daihyo_name" => "役所　祐治",
      "taxagency_corporate_number" => "0004657980123",
      "full_address" => "神奈川県大和市代官４５００",
      "tel" => "0962670999",
    }
  }

  describe "保証元の特定" do
    let(:internal_user) { create :internal_user }
    let!(:entity) { create :entity }
    let!(:sb_client) { create :sb_client, entity: entity }
    let(:sb_guarantee_exam_request) { create :sb_guarantee_exam_request }
    let(:exam_form) { Exam::RegistrationForm.new(sb_client, internal_user, sb_guarantee_exam_request) }
    context "保証元情報が存在しない場合" do
      let(:res) {
        exam_form.specify_client({})
      }
      it "クライアントを保証元として設定する" do
        expect(res.entity).to eq sb_client.entity
      end
    end

    context "保証元情報が存在する場合" do
      let(:res) {
        exam_form.specify_client(
          exam_form.adjust_to_client_attributes(client_hash)
        )
      }
      it "保証元が取得できる" do
        expect(res.company_name).to eq Utils::StringUtils.to_zenkaku client_hash["cl_company_name"]
        expect(res.daihyo_name).to eq Utils::StringUtils.to_zenkaku client_hash["cl_daihyo_name"]
        expect(res.taxagency_corporate_number).to eq client_hash["cl_taxagency_corporate_number"]
        expect(res.prefecture.name + res.address).to eq Utils::StringUtils.to_zenkaku client_hash["cl_full_address"]
        expect(res.tel).to eq client_hash["cl_tel"]
      end
    end
  end
  describe "保証先の特定" do
    let(:internal_user) { create :internal_user }
    let(:sb_client) { create :sb_client }
    let(:sb_guarantee_exam_request) { create :sb_guarantee_exam_request }
    let(:exam_form) { Exam::RegistrationForm.new(sb_client, internal_user, sb_guarantee_exam_request) }
    context "既存の保証先と企業名と代表者名で一致した場合" do
      let(:res) {
        exam_form.specify_customer(
          exam_form.adjust_to_customer_attributes(
            customer_hash
          )
        )
      }
      it "保証先が取得できる" do
        expect(res.company_name).to eq Utils::StringUtils.to_zenkaku customer_hash["company_name"]
        expect(res.daihyo_name).to eq Utils::StringUtils.to_zenkaku customer_hash["daihyo_name"]
        expect(res.taxagency_corporate_number).to eq customer_hash["taxagency_corporate_number"]
        expect(res.prefecture.name + res.address).to eq Utils::StringUtils.to_zenkaku customer_hash["full_address"]
        expect(res.tel).to eq customer_hash["tel"]
      end
    end
  end

  describe "保証審査依頼追加" do
    context "add_examでclient_hashが空の{}の場合" do
      let(:client_hash) { {} } # GMO以外は空のhash

      let!(:exam) { exam_form.add_exam(client_hash, customer_hash, exam_hash) }
      it "SBクライアント＝保証元の審査依頼が作成される" do
        expect(exam.sb_client).to eq sb_client
        expect(exam.sb_guarantee_client.entity).to eq sb_client.entity
        expect(exam.sb_guarantee_customer.company_name).to eq customer_hash["company_name"]
        expect(exam.sb_guarantee_customer.entity).to be_present
        expect(exam.sb_guarantee_exam_request).to be_present
      end
      it "フォームに審査依頼が１件追加されている" do
        expect(exam_form.exams.size).to eq 1
      end
    end
    context "add_examでclient_hashがnilの場合" do
      let(:client_hash) { nil } # GMO以外は空のhash

      let!(:exam) { exam_form.add_exam(client_hash, customer_hash, exam_hash) }
      it "空のHashとして扱われ、SBクライアント＝保証元の審査依頼が作成される" do
        expect(exam.sb_client).to eq sb_client
        expect(exam.sb_guarantee_client.entity).to eq sb_client.entity
        expect(exam.sb_guarantee_customer.company_name).to eq customer_hash["company_name"]
        expect(exam.sb_guarantee_customer.entity).to be_present
        expect(exam.sb_guarantee_exam_request).to be_present
      end
      it "フォームに審査依頼が１件追加されている" do
        expect(exam_form.exams.size).to eq 1
      end
    end
    context "add_examでclient_hashが指定された場合" do
      let!(:exam) { exam_form.add_exam(client_hash, customer_hash, exam_hash) }
      it "空のHashとして扱われ、SBクライアント＝保証元の審査依頼が作成される" do
        expect(exam.sb_client).to eq sb_client
        expect(exam.sb_guarantee_client.entity).to_not eq sb_client.entity
        expect(exam.sb_guarantee_customer.company_name).to eq customer_hash["company_name"]
        expect(exam.sb_guarantee_customer.entity).to be_present
        expect(exam.sb_guarantee_exam_request).to be_present
      end
      it "フォームに審査依頼が１件追加されている" do
        expect(exam_form.exams.size).to eq 1
      end
    end
    context "企業が特定できない場合" do
      context "保証元の企業が特定できない場合" do
        let(:client_hash_daihyo_only_hit) {
          client_hash["cl_daihyo_name"] = entity.entity_profile.daihyo_name
          client_hash
        }
        let!(:exam) { exam_form.add_exam(client_hash_daihyo_only_hit, customer_hash, exam_hash) }
        it "保証元のentityがnil、ステータスが企業未特定になる" do
          expect(exam.sb_guarantee_client.entity).to be_nil
          expect(exam.sb_guarantee_customer.entity).to be_present
        end
      end
      context "保証先の企業が特定できない場合" do
        let(:customer_hash_daihyo_only_hit) {
          customer_hash["daihyo_name"] = entity.entity_profile.daihyo_name
          customer_hash
        }
        let!(:exam) { exam_form.add_exam(client_hash, customer_hash_daihyo_only_hit, exam_hash) }
        it "保証先のentityがnil、ステータスが企業未特定になる" do
          expect(exam.sb_guarantee_customer.entity).to be_nil
          expect(exam.sb_guarantee_client.entity).to be_present
        end
      end
    end
  end

  describe "保証審査依頼保存" do
    context "企業特定とステータス" do
      context "企業特定が可能な保証審査依頼を1件追加して保存する" do
        # 新規Entityを作成するパターンで企業特定が完了する
        let!(:exam) { exam_form.add_exam(client_hash, customer_hash, exam_hash) }
        let!(:saved_exams) { exam_form.save_exams }
        it "保証審査依頼が保存され、企業特定状態になる" do
          target = saved_exams.first
          expect(target.persisted?).to eq true
          expect(target.sb_guarantee_client.persisted?).to eq true
          expect(target.sb_guarantee_customer.persisted?).to eq true
          expect(target.sb_guarantee_client.entity).to be_present
          expect(target.sb_guarantee_customer.entity).to be_present
          expect(target.status).to eq Status::ExamStatus::READY_FOR_EXAM
        end
      end
      context "企業が特定できない場合" do
        context "保証元の企業が特定できない場合" do
          let(:client_hash_daihyo_only_hit) {
            client_hash["cl_daihyo_name"] = entity.entity_profile.daihyo_name
            client_hash
          }
          let!(:exam) { exam_form.add_exam(client_hash_daihyo_only_hit, customer_hash, exam_hash) }
          let!(:saved_exams) { exam_form.save_exams }
          it "保証審査依頼が保存され、保証元が特定できず企業未特定になる" do
            target = saved_exams.first
            expect(target.persisted?).to eq true
            expect(target.sb_guarantee_client.persisted?).to eq true
            expect(target.sb_guarantee_customer.persisted?).to eq true
            expect(target.sb_guarantee_client.entity).to be_nil
            expect(target.sb_guarantee_customer.entity).to be_present
            expect(target.status).to eq Status::ExamStatus::COMPANY_NOT_DETECTED
          end
        end
        context "保証先の企業が特定できない場合" do
          let(:customer_hash_daihyo_only_hit) {
            customer_hash["daihyo_name"] = entity.entity_profile.daihyo_name
            customer_hash
          }
          let!(:exam) { exam_form.add_exam(client_hash, customer_hash_daihyo_only_hit, exam_hash) }
          let!(:saved_exams) { exam_form.save_exams }
          it "保証審査依頼が保存され、保証先が特定できず企業未特定になる" do
            target = saved_exams.first
            expect(target.persisted?).to eq true
            expect(target.sb_guarantee_client.persisted?).to eq true
            expect(target.sb_guarantee_customer.persisted?).to eq true
            expect(target.sb_guarantee_client.entity).to be_present
            expect(target.sb_guarantee_customer.entity).to be_nil
            expect(target.status).to eq Status::ExamStatus::COMPANY_NOT_DETECTED
          end
        end
      end
    end
    context "企業特定と再利用" do
      context "同じ保証元に対して2件の保証先が存在する審査依頼を保存する" do
        # 新規Entityを作成するパターンで企業特定が完了する
        let!(:exam) { exam_form.add_exam(client_hash, customer_hash, exam_hash) }
        let!(:exam2) { exam_form.add_exam(client_hash, customer_hash_2, exam_hash) }
        let!(:saved_exams) { exam_form.save_exams }
        it "1件目の保証元が2件目で再利用されていること" do
          target = saved_exams.first
          target2 = saved_exams[1]
          expect(target.sb_guarantee_client.company_name).to eq client_hash["cl_company_name"]
          expect(target.sb_guarantee_client).to eq target2.sb_guarantee_client
          expect(target.sb_guarantee_customer).not_to eq target2.sb_guarantee_customer
        end
      end
      context "異なる保証元からの同じ保証先に対する審査依頼を保存する" do
        # 新規Entityを作成するパターンで企業特定が完了する
        let!(:exam) { exam_form.add_exam(client_hash, customer_hash, exam_hash) }
        let!(:exam2) { exam_form.add_exam(client_hash_2, customer_hash, exam_hash) }
        let!(:saved_exams) { exam_form.save_exams }
        it "1件目の保証先が2件目で再利用されていること" do
          target = saved_exams.first
          target2 = saved_exams[1]
          expect(target.sb_guarantee_customer.company_name).to eq customer_hash["company_name"]
          expect(target.sb_guarantee_customer).to eq target2.sb_guarantee_customer
          expect(target.sb_guarantee_client).not_to eq target2.sb_guarantee_client
        end
      end
    end
  end

  describe "バリデーション" do
    describe "審査依頼" do
      context "審査依頼が０件の場合" do
        # 何もしないでいきなりバリデーションをかける
        it "無効である" do
          expect(exam_form.valid?).to eq false
          expect(exam_form.errors).to be_added(:exams, :not_empty)
        end
      end
    end
    context "審査の情報にバリデーションエラーがある場合" do
      let(:exam_hash_over_words) {
        exam_hash["transaction_contents"] = "あ" * 256
        exam_hash
      }
      let!(:exam) { exam_form.add_exam(client_hash, customer_hash, exam_hash_over_words) }
      it "無効である" do
        expect(exam_form.valid?).to eq false
        expect(exam_form.errors.full_messages).to be_include "取り扱い商品は255文字以内で入力してください[1行目]"
      end
    end
    context "保証元の情報にバリデーションエラーがある場合" do
      let(:client_hash_ng) {
        client_hash["cl_taxagency_corporate_number"] = "AAA"
        client_hash
      }
      let!(:exam) { exam_form.add_exam(client_hash_ng, customer_hash, exam_hash) }
      it "無効である" do
        expect(exam_form.valid?).to eq false
        expect(exam_form.errors.full_messages).to be_include "法人番号は数字のみで入力してください[1行目]"
      end
    end
    context "保証先の情報にバリデーションエラーがある場合" do
      let(:customer_hash_ng) {
        customer_hash["tel"] = "神奈川県大和市福田４５００"
        customer_hash
      }
      let!(:exam) { exam_form.add_exam(client_hash, customer_hash_ng, exam_hash) }
      it "無効である" do
        expect(exam_form.valid?).to eq false
        expect(exam_form.errors.full_messages).to be_include "電話番号は10桁または11桁で入力してください[1行目]"
      end
    end
    describe "複数行にバリデーションエラーがある場合、エラー業を特定できるか" do
      context "保証元の情報に複数のバリデーションエラーがある場合" do
        let(:client_hash_ng) {
          client_hash["cl_taxagency_corporate_number"] = "AAA"
          client_hash
        }
        let!(:exam) { exam_form.add_exam(client_hash_ng, customer_hash, exam_hash) }
        let!(:exam2) { exam_form.add_exam(client_hash_ng, customer_hash, exam_hash) }
        let!(:exam3) { exam_form.add_exam(client_hash_ng, customer_hash, exam_hash) }
        it "行番号が指定されすべての行のエラーが表示される" do
          expect(exam_form.valid?).to eq false
          expect(exam_form.errors.full_messages).to be_include "法人番号は数字のみで入力してください[1行目]"
          expect(exam_form.errors.full_messages).to be_include "法人番号は数字のみで入力してください[2行目]"
          expect(exam_form.errors.full_messages).to be_include "法人番号は数字のみで入力してください[3行目]"
        end
      end
      context "保証先の情報に複数バリデーションエラーがある場合" do
        let(:customer_hash_ng) {
          customer_hash["tel"] = "神奈川県大和市福田４５００"
          customer_hash
        }

        let!(:exam) { exam_form.add_exam(client_hash, customer_hash_ng, exam_hash) }
        let!(:exam2) { exam_form.add_exam(client_hash, customer_hash_ng, exam_hash) }
        let!(:exam3) { exam_form.add_exam(client_hash, customer_hash_ng, exam_hash) }
        it "行番号が指定されすべての行のエラーが表示される" do
          expect(exam_form.valid?).to eq false
          expect(exam_form.errors.full_messages).to be_include "電話番号は10桁または11桁で入力してください[1行目]"
          expect(exam_form.errors.full_messages).to be_include "電話番号は10桁または11桁で入力してください[2行目]"
          expect(exam_form.errors.full_messages).to be_include "電話番号は10桁または11桁で入力してください[3行目]"
        end
      end
      context "審査の情報に複数バリデーションエラーがある場合" do
        let(:exam_hash_over_words) {
          exam_hash["transaction_contents"] = "あ" * 256
          exam_hash
        }
        let!(:exam) { exam_form.add_exam(client_hash, customer_hash, exam_hash_over_words) }
        let!(:exam2) { exam_form.add_exam(client_hash, customer_hash, exam_hash_over_words) }
        let!(:exam3) { exam_form.add_exam(client_hash, customer_hash, exam_hash_over_words) }
        it "無効である" do
          expect(exam_form.valid?).to eq false
          expect(exam_form.errors.full_messages).to be_include "取り扱い商品は255文字以内で入力してください[1行目]"
          expect(exam_form.errors.full_messages).to be_include "取り扱い商品は255文字以内で入力してください[2行目]"
          expect(exam_form.errors.full_messages).to be_include "取り扱い商品は255文字以内で入力してください[3行目]"
        end
      end
    end
  end

  describe "ファイル読み込み" do
    let(:current_user) { create :internal_user }
    let(:form) { Exam::RegistrationForm.initFromFile(sb_client, current_user, file) }
    let(:file) { fixture_file_upload("files/exam_registration/ok.xls") }
    context "異常なファイルを読み込んだ場合" do
      context "空のExcel" do
        let(:file) { fixture_file_upload("files/exam_registration/empty.xlsx") }
        it "初期化できるがバリデーションエラーになる" do
          expect(form).to be_invalid
        end
      end
      context "旧Excelの拡張子の場合" do
        let(:file) { fixture_file_upload("files/exam_registration/ok.xls") }
        it "読み込みエラーになる" do
          expect {
            form
          }.to raise_error(ArgumentError)
        end
      end
      context "画像ファイルの場合" do
        let(:file) { fixture_file_upload("files/exam_registration/logo.jpg") }

        it "読み込みエラーになる" do
          expect {
            form
          }.to raise_error(ArgumentError)
        end
      end
    end

    context "内容がNGなファイルを読み込んだ場合" do
      let(:file) { fixture_file_upload("files/exam_registration/ng.xlsx") }
      it "初期化できるがバリデーションエラーになる" do
        expect(form).to be_invalid
      end
    end
    context "正常なファイルを読み込んだ場合" do
      context "保証元＝クライアントのフォーマットの場合" do
        let(:file) { fixture_file_upload("files/exam_registration/ok_no_client.xlsx") }
        it "初期化できる" do
          expect(form).to be_valid
        end
        it "審査が３行ある" do
          expect(form.exams.size).to eq 3
        end
        it "審査がファイルから正しく格納されている" do
          exam = form.exams.first
          expect(exam.transaction_contents).to eq "牛肉"
          expect(exam.payment_method_id).to eq PaymentMethod.find_by_name("末・末").id
          expect(exam.payment_method_optional).to eq "決済条件補足"
          expect(exam.new_transaction).to eq "既存" == "新規"
          expect(exam.transaction_years).to eq 2
          expect(exam.payment_delayed).to eq "無" == "有"
          expect(exam.payment_delayed_memo).to eq "支払い遅延の状況"
          expect(exam.payment_method_changed).to eq "無" == "有"
          expect(exam.payment_method_changed_memo).to eq "支払条件変更内容"
          expect(exam.other_companies_ammount).to eq 900000
          expect(exam.other_guarantee_companies).to eq "保証会社名"
          expect(exam.guarantee_amount_hope).to eq 5000000
        end
        it "保証先がファイルから正しく格納されている" do
          customer = form.exams.first.sb_guarantee_customer
          expect(customer.company_name).to eq Utils::CompanyNameUtils.to_zenkaku_name "株式会社PONY"
          expect(customer.daihyo_name).to eq "牧場　牛男"
          expect(customer.prefecture).to eq Prefecture.find_by_name("東京都")
          expect(customer.address).to eq Utils::StringUtils.to_zenkaku "新宿区西新宿３－６－８"
          expect(customer.tel).to eq "0399999999"
          expect(customer.taxagency_corporate_number).to eq "1234567890123"
        end
        it "保証元がSBクライアントである" do
          client = form.exams.first.sb_guarantee_client
          expect(client.company_name).to eq sb_client.name
          expect(client.daihyo_name).to eq sb_client.daihyo_name
          expect(client.prefecture).to eq sb_client.prefecture
          expect(client.address).to eq sb_client.address
          expect(client.tel).to eq sb_client.tel
          expect(client.taxagency_corporate_number).to eq sb_client.taxagency_corporate_number
          expect(client.sb_client).to eq sb_client
        end
      end
      context "保証元を指定したフォーマットの場合" do
        let(:file) { fixture_file_upload("files/exam_registration/ok_with_client.xlsx") }
        it "初期化できる" do
          expect(form).to be_valid
        end
        it "審査が３行ある" do
          expect(form.exams.size).to eq 3
        end
        it "審査がファイルから正しく格納されている" do
          exam = form.exams.first
          expect(exam.accepted_at).to be_present
          expect(exam.transaction_contents).to eq "牛肉"
          expect(exam.payment_method_id).to eq PaymentMethod.find_by_name("末・末").id
          expect(exam.payment_method_optional).to eq "決済条件補足"
          expect(exam.new_transaction).to eq "既存" == "新規"
          expect(exam.transaction_years).to eq 2
          expect(exam.payment_delayed).to eq "無" == "有"
          expect(exam.payment_delayed_memo).to eq "支払い遅延の状況"
          expect(exam.payment_method_changed).to eq "無" == "有"
          expect(exam.payment_method_changed_memo).to eq "支払条件変更内容"
          expect(exam.other_companies_ammount).to eq 900000
          expect(exam.other_guarantee_companies).to eq "保証会社名"
          expect(exam.guarantee_amount_hope).to eq 5000000
        end
        it "保証先がファイルから正しく格納されている" do
          customer = form.exams.first.sb_guarantee_customer
          expect(customer.company_name).to eq Utils::CompanyNameUtils.to_zenkaku_name "株式会社PONY"
          expect(customer.daihyo_name).to eq "牧場　牛男"
          expect(customer.prefecture).to eq Prefecture.find_by_name("東京都")
          expect(customer.address).to eq Utils::StringUtils.to_zenkaku "新宿区西新宿３－６－８"
          expect(customer.tel).to eq "0399999999"
          expect(customer.taxagency_corporate_number).to eq "1234567890123"
        end
        it "保証元がファイルから正しく格納されている" do
          client = form.exams.first.sb_guarantee_client
          expect(client.company_name).to eq "千急株式会社"
          expect(client.daihyo_name).to eq "田中　和夫"
          expect(client.prefecture).to eq Prefecture.find_by_name("東京都")
          expect(client.address).to eq Utils::StringUtils.to_zenkaku "新宿区西新宿３－６－１０"
          expect(client.tel).to eq "0399999900"
          expect(client.taxagency_corporate_number).to eq "1234567890999"
          expect(client.sb_client).to eq sb_client
        end
      end
    end
  end
  describe "ActiveStrageからのファイル読み込み" do
    let(:current_user) { create :internal_user }
    let(:form) { Exam::RegistrationForm.initFromFile(sb_client, current_user, file) }
    let(:file) { fixture_file_upload("files/exam_registration/ok_no_client.xlsx") }
    let(:form_rev) { Exam::RegistrationForm.initFromGuaranteeExamRequestId(sb_client, current_user, form.sb_guarantee_exam_request.id) }
    context "ファイルから読み込んだformと、ActiveStrageから復元したファイルから読み込んだformを比較する" do
      it "初期化できる" do
        expect(form_rev).to be_valid
      end
      it "審査が３行ある" do
        expect(form_rev.exams.size).to eq 3
      end
      it "受付日以外の生成結果が同じである" do
        exam_rev = form_rev.exams.first
        exam = form_rev.exams.first
        expect(exam_rev.accepted_at).to be_present
        expect(exam_rev.transaction_contents).to eq exam.transaction_contents
        expect(exam_rev.payment_method_id).to eq exam.payment_method_id
        expect(exam_rev.payment_method_optional).to eq exam.payment_method_optional
        expect(exam_rev.new_transaction).to eq exam.new_transaction
        expect(exam_rev.transaction_years).to eq exam.transaction_years
        expect(exam_rev.payment_delayed).to eq exam.payment_delayed
        expect(exam_rev.payment_delayed_memo).to eq exam.payment_delayed_memo
        expect(exam_rev.payment_method_changed).to eq exam.payment_method_changed
        expect(exam_rev.payment_method_changed_memo).to eq exam.payment_method_changed_memo
        expect(exam_rev.other_companies_ammount).to eq exam.other_companies_ammount
        expect(exam_rev.other_guarantee_companies).to eq exam.other_guarantee_companies
        expect(exam_rev.guarantee_amount_hope).to eq exam.guarantee_amount_hope
      end
    end
  end
end
