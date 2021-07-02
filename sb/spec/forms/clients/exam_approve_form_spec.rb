require "rails_helper"

RSpec.describe Client::ExamApproveForm, type: :model do
  let(:client) { create :sb_client, :client_exam_form }
  let(:client_has_file) { create :sb_client, :has_file }
  let(:client_has_exam) { create :sb_client, :has_exam }
  let(:client_has_exam_available_flag_false) { create :sb_client, :has_exam_available_flag_false }
  let(:client_has_no_entity) { create :sb_client, :has_no_entity }

  describe "初期化" do
    context "初期表示" do
      let(:form) { Client::ExamForm.new(nil, client_has_file) }
      it "一覧画面で選択されたデータのsb_clientが表示される" do
        expect(form.area_id).to eq client_has_file.area_id
        expect(form.sb_tanto_id).to eq client_has_file.sb_tanto_id
        expect(form.name).to eq client_has_file.name
        expect(form.daihyo_name).to eq client_has_file.daihyo_name
        expect(form.zip_code).to eq client_has_file.zip_code
        expect(form.prefecture_code).to eq client_has_file.prefecture_code
        expect(form.address).to eq client_has_file.address
        expect(form.tel).to eq client_has_file.tel
        expect(form.industry_id).to eq client_has_file.industry_id
        expect(form.industry_optional).to eq client_has_file.industry_optional
        expect(form.established_in).to eq client_has_file.established_in
        expect(form.annual_sales).to eq client_has_file.annual_sales
        expect(form.capital).to eq client_has_file.capital
        expect(form.output_registration_form_file.filename).to eq "registration_form_file1.pdf"
        expect(form.output_other_files.first.filename).to eq "other_file1.pdf"
      end
    end

    context "初期表示時にsb_client_examが存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client) }
      it "sb_client_examの項目がnilである" do
        expect(form.reject_reason).to eq nil
        expect(form.anti_social).to eq nil
        expect(form.anti_social_memo).to eq nil
        expect(form.tsr_score).to eq nil
        expect(form.tdb_score).to eq nil
        expect(form.communicate_memo).to eq nil
      end
    end

    context "初期表示時に有効フラグがtrueのsb_client_examが存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam_available_flag_false) }
      it "sb_client_examの項目がnilである" do
        expect(form.reject_reason).to eq nil
        expect(form.anti_social).to eq nil
        expect(form.anti_social_memo).to eq nil
        expect(form.tsr_score).to eq nil
        expect(form.tdb_score).to eq nil
        expect(form.communicate_memo).to eq nil
      end
    end

    context "初期表示時に有効フラグがtrueのsb_client_examが存在する場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "sb_client_examの項目がnilである" do
        expect(form.reject_reason).to eq "否決理理由"
        expect(form.anti_social).to eq true
        expect(form.anti_social_memo).to eq "反社メモ"
        expect(form.tsr_score).to eq "55"
        expect(form.tdb_score).to eq "66"
        expect(form.communicate_memo).to eq "社内連絡メモ"
      end
    end

    context "ab情報が存在する場合" do
      let!(:customer) { create :customer_master, house_company_code: client_has_exam.entity.house_company_code }
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "ab情報がありである" do
        expect(form.ab_info).to eq "あり"
      end
    end

    context "ab情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "ab情報がなしである" do
        expect(form.ab_info).to eq "なし"
      end
    end

    context "bl情報が存在する場合" do
      let!(:bl_info) { create :accs_bl_info, corporate_code: client_has_exam.entity.house_company_code }
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "bl情報がありである" do
        expect(form.bl_info).to eq "あり"
      end
    end

    context "bl情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "bl情報がなしである" do
        expect(form.bl_info).to eq "なし"
      end
    end

    context "by情報が存在する場合" do
      let!(:by_info) { create :by_customer, entity_id: client_has_exam.entity.id }
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "by情報がありである" do
        expect(form.by_info).to eq "あり"
      end
    end

    context "by情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "by情報がなしである" do
        expect(form.by_info).to eq "なし"
      end
    end

    context "審査結果情報が存在する場合" do
      let!(:guarantee_client) { create :sb_guarantee_client }
      let!(:guarantee_customer) { create :sb_guarantee_customer, entity_id: client_has_exam.entity.id }
      let!(:guarantee_exam) { create :sb_guarantee_exam, sb_guarantee_client_id: guarantee_client.id, sb_guarantee_customer_id: guarantee_customer.id }
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "審査結果情報がありである" do
        expect(form.exam_info).to eq "あり"
      end
    end

    context "審査結果情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "審査結果情報がなしである" do
        expect(form.bl_info).to eq "なし"
      end
    end

    context "entity情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_no_entity) }
      it "各情報が設定されない" do
        expect(form.exam_info).to eq nil
        expect(form.ab_info).to eq nil
        expect(form.bl_info).to eq nil
      end
    end
  end
end