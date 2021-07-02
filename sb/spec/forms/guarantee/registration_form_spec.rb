require "rails_helper"

RSpec.describe Guarantee::RegistrationForm, type: :model do
  let(:internal_user) { create :internal_user }
  let(:entity) { create :entity }
  let(:sb_client) { create :sb_client, entity: entity }
  let(:sb_guarantee_customer_1) { create :sb_guarantee_customer, company_name: "株式会社PONY" }
  let(:sb_guarantee_customer_2) { create :sb_guarantee_customer, company_name: "株式会社花ソニック" }
  let(:sb_guarantee_customer_3) { create :sb_guarantee_customer, company_name: "株式会社SHARK" }
  let!(:sb_guarantee_exam_1) {
    create :sb_guarantee_exam, :approved, exam_search_key: "CI001",
                                          sb_client: sb_client, sb_guarantee_customer: sb_guarantee_customer_1
  }
  let!(:sb_guarantee_exam_2) {
    create :sb_guarantee_exam, :approved, exam_search_key: "CI002",
                                          sb_client: sb_client, sb_guarantee_customer: sb_guarantee_customer_2
  }
  let!(:sb_guarantee_exam_3) {
    create :sb_guarantee_exam, :approved, exam_search_key: "CI003",
                                          sb_client: sb_client, sb_guarantee_customer: sb_guarantee_customer_3
  }
  let(:sb_guarantee_request) { create :sb_guarantee_request }
  let(:guarantee_form) { Guarantee::RegistrationForm.new(sb_client, internal_user, sb_guarantee_request) }
  let(:guarantee_hash) {
    {
      "cl_company_name" => "株式会社ヨントリー",
      "cl_daihyo_name" => "鳥居　太郎",
      "company_name" => "有限会社千本桜酒店",
      "daihyo_name" => "千本　桜",
      "guarantee_start_at" => "2021/07/02", # 保証希望額
      "guarantee_end_at" => "2021/08/02", # 保証希望額
      "guarantee_amount_hope" => 5000000, # 保証希望額
      "exam_search_key" => sb_guarantee_exam.exam_search_key,
    }
  }

  # describe "バリデーション" do
  #   describe "審査依頼" do
  #     context "審査依頼が０件の場合" do
  #       # 何もしないでいきなりバリデーションをかける
  #       it "無効である" do
  #         expect(guarantee_form.valid?).to eq false
  #         expect(guarantee_form.errors).to be_added(:exams, :not_empty)
  #       end
  #     end
  #   end
  #   context "審査の情報にバリデーションエラーがある場合" do
  #     let(:exam_hash_over_words) {
  #       exam_hash["transaction_contents"] = "あ" * 256
  #       exam_hash
  #     }
  #     let!(:exam) { guarantee_form.add_exam(client_hash, customer_hash, exam_hash_over_words) }
  #     it "無効である" do
  #       expect(guarantee_form.valid?).to eq false
  #       expect(guarantee_form.errors.full_messages).to be_include "取り扱い商品は255文字以内で入力してください[1行目]"
  #     end
  #   end
  #   context "保証元の情報にバリデーションエラーがある場合" do
  #     let(:client_hash_ng) {
  #       client_hash["cl_taxagency_corporate_number"] = "AAA"
  #       client_hash
  #     }
  #     let!(:exam) { guarantee_form.add_exam(client_hash_ng, customer_hash, exam_hash) }
  #     it "無効である" do
  #       expect(guarantee_form.valid?).to eq false
  #       expect(guarantee_form.errors.full_messages).to be_include "法人番号は数字のみで入力してください[1行目]"
  #     end
  #   end
  #   context "保証先の情報にバリデーションエラーがある場合" do
  #     let(:customer_hash_ng) {
  #       customer_hash["tel"] = "神奈川県大和市福田４５００"
  #       customer_hash
  #     }
  #     let!(:exam) { guarantee_form.add_exam(client_hash, customer_hash_ng, exam_hash) }
  #     it "無効である" do
  #       expect(guarantee_form.valid?).to eq false
  #       expect(guarantee_form.errors.full_messages).to be_include "電話番号は10桁または11桁で入力してください[1行目]"
  #     end
  #   end
  #   describe "複数行にバリデーションエラーがある場合、エラー業を特定できるか" do
  #     context "保証元の情報に複数のバリデーションエラーがある場合" do
  #       let(:client_hash_ng) {
  #         client_hash["cl_taxagency_corporate_number"] = "AAA"
  #         client_hash
  #       }
  #       let!(:exam) { guarantee_form.add_exam(client_hash_ng, customer_hash, exam_hash) }
  #       let!(:exam2) { guarantee_form.add_exam(client_hash_ng, customer_hash, exam_hash) }
  #       let!(:exam3) { guarantee_form.add_exam(client_hash_ng, customer_hash, exam_hash) }
  #       it "行番号が指定されすべての行のエラーが表示される" do
  #         expect(guarantee_form.valid?).to eq false
  #         expect(guarantee_form.errors.full_messages).to be_include "法人番号は数字のみで入力してください[1行目]"
  #         expect(guarantee_form.errors.full_messages).to be_include "法人番号は数字のみで入力してください[2行目]"
  #         expect(guarantee_form.errors.full_messages).to be_include "法人番号は数字のみで入力してください[3行目]"
  #       end
  #     end
  #     context "保証先の情報に複数バリデーションエラーがある場合" do
  #       let(:customer_hash_ng) {
  #         customer_hash["tel"] = "神奈川県大和市福田４５００"
  #         customer_hash
  #       }

  #       let!(:exam) { guarantee_form.add_exam(client_hash, customer_hash_ng, exam_hash) }
  #       let!(:exam2) { guarantee_form.add_exam(client_hash, customer_hash_ng, exam_hash) }
  #       let!(:exam3) { guarantee_form.add_exam(client_hash, customer_hash_ng, exam_hash) }
  #       it "行番号が指定されすべての行のエラーが表示される" do
  #         expect(guarantee_form.valid?).to eq false
  #         expect(guarantee_form.errors.full_messages).to be_include "電話番号は10桁または11桁で入力してください[1行目]"
  #         expect(guarantee_form.errors.full_messages).to be_include "電話番号は10桁または11桁で入力してください[2行目]"
  #         expect(guarantee_form.errors.full_messages).to be_include "電話番号は10桁または11桁で入力してください[3行目]"
  #       end
  #     end
  #     context "審査の情報に複数バリデーションエラーがある場合" do
  #       let(:exam_hash_over_words) {
  #         exam_hash["transaction_contents"] = "あ" * 256
  #         exam_hash
  #       }
  #       let!(:exam) { guarantee_form.add_exam(client_hash, customer_hash, exam_hash_over_words) }
  #       let!(:exam2) { guarantee_form.add_exam(client_hash, customer_hash, exam_hash_over_words) }
  #       let!(:exam3) { guarantee_form.add_exam(client_hash, customer_hash, exam_hash_over_words) }
  #       it "無効である" do
  #         expect(guarantee_form.valid?).to eq false
  #         expect(guarantee_form.errors.full_messages).to be_include "取り扱い商品は255文字以内で入力してください[1行目]"
  #         expect(guarantee_form.errors.full_messages).to be_include "取り扱い商品は255文字以内で入力してください[2行目]"
  #         expect(guarantee_form.errors.full_messages).to be_include "取り扱い商品は255文字以内で入力してください[3行目]"
  #       end
  #     end
  #   end
  # end

  describe "ファイル読み込み" do
    let(:current_user) { create :internal_user }
    let(:form) { Guarantee::RegistrationForm.initFromFile(sb_client, current_user, file) }
    let(:file) { fixture_file_upload("files/guarantee_registration/ok.xls") }
    context "異常なファイルを読み込んだ場合" do
      context "空のExcel" do
        let(:file) { fixture_file_upload("files/guarantee_registration/empty.xlsx") }
        it "初期化できるがバリデーションエラーになる" do
          expect(form).to be_invalid
        end
      end
      context "旧Excelの拡張子の場合" do
        let(:file) { fixture_file_upload("files/guarantee_registration/ok.xls") }
        it "読み込みエラーになる" do
          expect {
            form
          }.to raise_error(ArgumentError)
        end
      end
      context "画像ファイルの場合" do
        let(:file) { fixture_file_upload("files/guarantee_registration/logo.jpg") }

        it "読み込みエラーになる" do
          expect {
            form
          }.to raise_error(ArgumentError)
        end
      end
    end

    context "内容がNGなファイルを読み込んだ場合" do
      let(:file) { fixture_file_upload("files/guarantee_registration/ng.xlsx") }
      it "初期化できるがバリデーションエラーになる" do
        expect(form).to be_invalid
      end
    end
    context "正常なファイルを読み込んだ場合" do
      context "保証元＝クライアントのフォーマットの場合" do
        let(:file) { fixture_file_upload("files/guarantee_registration/ok_no_client.xlsx") }
        it "初期化できる" do
          expect(form).to be_valid
        end
        it "審査が３行ある" do
          expect(form.guarantees.size).to eq 3
        end
        it "保証依頼がファイルから正しく格納されている" do
          guarantee = form.guarantees.first
          expect(guarantee.exam_search_key).to eq "CI001"
          expect(guarantee.client_company_name).to be_blank
          expect(guarantee.client_daihyo_name).to be_blank
          expect(guarantee.company_name).to eq Utils::StringUtils.to_zenkaku("株式会社PONY")
          expect(guarantee.daihyo_name).to eq "牧場　牛男"
          expect(guarantee.guarantee_start_at).to eq Date.parse("2021/7/4")
          expect(guarantee.guarantee_end_at).to eq Date.parse("2021/8/1")
          expect(guarantee.guarantee_amount_hope).to eq 5000000
        end
      end
      context "保証元を指定したフォーマットの場合" do
        let(:file) { fixture_file_upload("files/guarantee_registration/ok_with_client.xlsx") }
        it "初期化できる" do
          expect(form).to be_valid
        end
        it "審査が３行ある" do
          expect(form.guarantees.size).to eq 3
        end
        it "保証依頼がファイルから正しく格納されている" do
          guarantee = form.guarantees.first
          expect(guarantee.exam_search_key).to eq "CI001"
          expect(guarantee.client_company_name).to eq "千急株式会社"
          expect(guarantee.client_daihyo_name).to eq "田中　和夫"
          expect(guarantee.company_name).to eq Utils::StringUtils.to_zenkaku("株式会社PONY")
          expect(guarantee.daihyo_name).to eq "牧場　牛男"
          expect(guarantee.guarantee_start_at).to eq Date.parse("2021/7/3")
          expect(guarantee.guarantee_end_at).to eq Date.parse("2021/8/7")
          expect(guarantee.guarantee_amount_hope).to eq 7500000
        end
      end
    end
  end
  describe "ActiveStorageからのファイル読み込み" do
    let(:current_user) { create :internal_user }
    let(:form) { Guarantee::RegistrationForm.initFromFile(sb_client, current_user, file) }
    let(:file) { fixture_file_upload("files/guarantee_registration/ok_no_client.xlsx") }
    let(:form_rev) { Guarantee::RegistrationForm.initFromGuaranteeRequestId(sb_client, current_user, form.sb_guarantee_request.id) }
    context "ファイルから読み込んだformと、ActiveStorageから復元したファイルから読み込んだformを比較する" do
      it "初期化できる" do
        expect(form_rev).to be_valid
      end
      it "審査が３行ある" do
        expect(form_rev.guarantees.size).to eq 3
      end
      it "受付日以外の生成結果が同じである" do
        guarantee_rev = form_rev.guarantees.first
        guarantee = form.guarantees.first
        expect(guarantee_rev.accepted_at).to be_present
        expect(guarantee_rev.exam_search_key).to eq guarantee.exam_search_key
        expect(guarantee_rev.client_company_name).to eq guarantee.client_company_name
        expect(guarantee_rev.client_daihyo_name).to eq guarantee.client_daihyo_name
        expect(guarantee_rev.company_name).to eq guarantee.company_name
        expect(guarantee_rev.daihyo_name).to eq guarantee.daihyo_name
        expect(guarantee_rev.guarantee_start_at).to eq guarantee.guarantee_start_at
        expect(guarantee_rev.guarantee_end_at).to eq guarantee.guarantee_end_at
        expect(guarantee_rev.guarantee_amount_hope).to eq guarantee.guarantee_amount_hope
      end
    end
  end
end
