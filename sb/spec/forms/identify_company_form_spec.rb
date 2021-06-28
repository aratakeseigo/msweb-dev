require "rails_helper"

RSpec.describe IdentifyCompanyForm, type: :model do
  describe "バリデーション" do
    let(:form) { IdentifyCompanyForm.new(
        classification: "1",
        id: "1",
        company_name: "株式会社 〇〇〇",
        daihyo_name: "苗字　名前",
        taxagency_corporate_number: "2222222222222",
        prefecture_code: "13",
        address: "東京都新宿区１－１－１",
        daihyo_tel: "0311112222",
        established: "200001",
        zip_code: "1234567",
        path: "/clients/list") }

    context "全て正常場合" do
      it "有効である" do
          expect(form).not_to be_invalid
      end
    end

    context "起動元区分確認" do
      before do
        @sb_client = FactoryBot.create(:identify_company_sb_client1)
      end
      it "クライアント一覧である" do
        obj = IdentifyCompanyForm.init(classification: "1", id: @sb_client.id)
        expect(obj.instance_of?(IdentifyCompanyForm::Client)).to eq(true)
      end
      it "審査一覧である" do
        obj = IdentifyCompanyForm.init(classification: "2", id: @sb_client.id)
        expect(obj.instance_of?(IdentifyCompanyForm::Exam)).to eq(true)
      end
      it "保証一覧である" do
        obj = IdentifyCompanyForm.init(classification: "3", id: @sb_client.id)
        expect(obj.instance_of?(IdentifyCompanyForm::Guarantee)).to eq(true)
      end
    end

    context "クライアント一覧からのステータス更新" do
      before do
        @sb_client = FactoryBot.create(:identify_company_sb_client1)
        @entity = FactoryBot.create(:identify_company_entity1)
        IdentifyCompanyForm.update_status_and_entity(classification: "1", id: @sb_client.id, entity_id: @entity.id)
        @updated_sb_client = SbClient.find(@sb_client.id)
      end
      it "エンティティIDが登録される" do
          expect(@updated_sb_client.entity_id).to eq @entity.id
      end
      it "SBクライアントのステータスがStatus::ClientStatus::READY_FOR_EXAMに更新される" do
          expect(@updated_sb_client.status_id).to eq Status::ClientStatus::READY_FOR_EXAM.id
      end
    end

    context "審査一覧からのステータス更新" do
      before do
        @sb_client = FactoryBot.create(:identify_company_sb_client1)
        @entity = FactoryBot.create(:identify_company_entity1)
        IdentifyCompanyForm.update_status_and_entity(classification: "2", id: @sb_client.id, entity_id: @entity.id)
        @updated_sb_client = SbClient.find(@sb_client.id)
      end
      it "エンティティIDが登録される" do
          expect(@updated_sb_client.entity_id).to eq @entity.id
      end
      it "SBクライアントのステータスがStatus::ExamStatus::READY_FOR_EXAMに更新される" do
          expect(@updated_sb_client.status_id).to eq Status::ExamStatus::READY_FOR_EXAM.id
      end
    end

    context "保証一覧からのステータス更新" do
      before do
        @sb_client = FactoryBot.create(:identify_company_sb_client1)
        @entity = FactoryBot.create(:identify_company_entity1)
        IdentifyCompanyForm.update_status_and_entity(classification: "3", id: @sb_client.id, entity_id: @entity.id)
        @updated_sb_client = SbClient.find(@sb_client.id)
      end
      it "エンティティIDが登録される" do
          expect(@updated_sb_client.entity_id).to eq @entity.id
      end
      it "SBクライアントのステータスがStatus::GuaranteeStatus::READY_FOR_CONFIRMに更新される" do
          expect(@updated_sb_client.status_id).to eq Status::GuaranteeStatus::READY_FOR_CONFIRM.id
      end
    end

    context "企業新規登録" do
      before do
        @sb_client = FactoryBot.create(:identify_company_sb_client5)
        @identify_company = IdentifyCompanyForm.new(classification: "1", id: @sb_client.id, company_name: @sb_client.name,
          daihyo_name: @sb_client.daihyo_name, zip_code: @sb_client.zip_code, prefecture_code: "13",
          address: @sb_client.address, daihyo_tel: @sb_client.tel, taxagency_corporate_number: @sb_client.taxagency_corporate_number,
          established: @sb_client.established_in, path: @clients_list_path)
      end
      subject { -> {@identify_company .create_entity} }
      it "Entityテーブルのレコードが１件が登録される" do
        is_expected.to change { Entity.all.size }.from(0).to(1)
      end
      it "EntityProfileテーブルのレコードが１件が登録される" do
        is_expected.to change { EntityProfile.all.size }.from(0).to(1)
      end
    end
  end
end
  