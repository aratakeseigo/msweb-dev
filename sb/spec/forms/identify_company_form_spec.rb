require "rails_helper"

RSpec.describe IdentifyCompanyForm, type: :model do
  let(:internal_user) { create :internal_user }
  let(:entity) { create :entity }
  let(:sb_client) { create :sb_client }
  let(:params_hash) {
    {
      "classification" => "client",
      "id" => sb_client.id,
      "company_name" => "未特定企業５",
      "daihyo_name" => "企業未特定　太郎５",
      "zip_code" => "1112222",
      "prefecture_code" => "13",
      "address" => "東京都新宿区１－１－１",
      "tel" => "11111111111",
      "established" => "200004",
      "taxagency_corporate_number" => "4444444444444"
        }
  }

  describe "バリデーション" do
    let(:identify_company) { IdentifyCompanyForm.init("client", params_hash) }
    context "全て正常場合" do
      it "有効である" do
          expect(identify_company).not_to be_invalid
      end
    end
  end

  describe "起動元区分確認" do
    context "クライアント一覧（classification => 'client'）" do
      let(:identify_company) { IdentifyCompanyForm.init("client", params_hash) }
      it "インスタンスがIdentifyCompanyForm::Clientである" do
        expect(identify_company.instance_of?(IdentifyCompanyForm::Client)).to eq(true)
      end
    end
    context "保証審査一覧（保証元）（classification => 'guarantee_client'）" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_client", params_hash) }
      it "インスタンスがIdentifyCompanyForm::GuaranteeClientである" do
        expect(identify_company.instance_of?(IdentifyCompanyForm::GuaranteeClient)).to eq(true)
      end
    end
    context "保証審査一覧（保証先）（classification => 'guarantee_customer'）" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_customer", params_hash) }
      it "インスタンスがIdentifyCompanyForm::GuaranteeCustomerである" do
        expect(identify_company.instance_of?(IdentifyCompanyForm::GuaranteeCustomer)).to eq(true)
      end
    end
  end

  describe "データ更新確認" do
    context "クライアント一覧からのステータス更新" do
      let(:identify_company) { IdentifyCompanyForm.init("client", params_hash) }
      before do
        identify_company.assign_entity(Entity.find entity.id)
        @updated_sb_client = SbClient.find(identify_company.id)
      end
      it "エンティティIDが登録される" do
          expect(@updated_sb_client.entity_id).to eq entity.id
      end
      it "SBクライアントのステータスがStatus::ClientStatus::READY_FOR_EXAMに更新される" do
          expect(@updated_sb_client.status_id).to eq Status::ClientStatus::READY_FOR_EXAM.id
      end
    end
    context "保証審査一覧(保証元)からのentity登録" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_client", params_hash) }
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      it "エンティティIDが登録される" do
        identify_company.id = sb_guarantee_exam.id
        entity_id = Entity.all.first.id
        SbGuaranteeClient.where(id: sb_guarantee_exam.sb_guarantee_client_id).update_all(entity_id: nil)

        identify_company.assign_entity(Entity.find entity_id)

        expect(SbGuaranteeClient.find(sb_guarantee_exam.sb_guarantee_client_id).entity_id).to eq entity_id
      end
    end
    context "保証審査一覧(保証先)からのentity登録" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_customer", params_hash) }
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      it "エンティティIDが登録される" do
        identify_company.id = sb_guarantee_exam.id
        entity_id = Entity.all.first.id
        SbGuaranteeCustomer.where(id: sb_guarantee_exam.sb_guarantee_customer_id).update_all(entity_id: nil)
        identify_company.assign_entity(Entity.find entity_id)

        expect(SbGuaranteeCustomer.find(sb_guarantee_exam.sb_guarantee_customer_id).entity_id).to eq entity_id
      end
    end

    context "保証審査一覧(保証元)からの保証元のみentity登録" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_client", params_hash) }
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      it "ステータスが更新されずStatus::ExamStatus::COMPANY_NOT_DETECTEDままである" do
        identify_company.id = sb_guarantee_exam.id
        entity_id = Entity.all.first.id
        sb_guarantee_exam.update(status: Status::ExamStatus::COMPANY_NOT_DETECTED )
        SbGuaranteeClient.where(id: sb_guarantee_exam.sb_guarantee_client_id).update_all(entity_id: nil)
        SbGuaranteeCustomer.where(id: sb_guarantee_exam.sb_guarantee_customer_id).update_all(entity_id: nil)

        identify_company.assign_entity(Entity.find entity_id)

        expect(SbGuaranteeExam.find(sb_guarantee_exam.id).status_id).to eq Status::ExamStatus::COMPANY_NOT_DETECTED.id
      end
    end

    context "保証審査一覧(保証先)からの保証先のみentity登録" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_customer", params_hash) }
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      it "ステータスが更新されずStatus::ExamStatus::COMPANY_NOT_DETECTEDままである" do
        identify_company.id = sb_guarantee_exam.id
        sb_guarantee_exam.update(status: Status::ExamStatus::COMPANY_NOT_DETECTED )
        entity_id = Entity.all.first.id
        SbGuaranteeClient.where(id: sb_guarantee_exam.sb_guarantee_client_id).update_all(entity_id: nil)
        SbGuaranteeCustomer.where(id: sb_guarantee_exam.sb_guarantee_customer_id).update_all(entity_id: nil)

        identify_company.assign_entity(Entity.find entity_id)

        expect(SbGuaranteeExam.find(sb_guarantee_exam.id).status_id).to eq Status::ExamStatus::COMPANY_NOT_DETECTED.id
      end
    end
  
    context "保証審査一覧(保証元)からの保証先特定済状態で保証元entity登録" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_client", params_hash) }
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      it "ステータスがStatus::ExamStatus::READY_FOR_EXAMに更新される" do
        identify_company.id = sb_guarantee_exam.id
        sb_guarantee_exam.update(status: Status::ExamStatus::COMPANY_NOT_DETECTED )
        entity_id = Entity.all.first.id
        SbGuaranteeClient.where(id: sb_guarantee_exam.sb_guarantee_client_id).update_all(entity_id: nil)
        SbGuaranteeCustomer.where(id: sb_guarantee_exam.sb_guarantee_customer_id).update_all(entity_id: entity_id)

        identify_company.assign_entity(Entity.find entity_id)

        expect(SbGuaranteeExam.find(sb_guarantee_exam.id).status_id).to eq Status::ExamStatus::READY_FOR_EXAM.id
      end
    end

    context "保証審査一覧(保証先)からの保証元特定済状態で保証先entity登録" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_customer", params_hash) }
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      it "ステータスがStatus::ExamStatus::READY_FOR_EXAMに更新される" do
        identify_company.id = sb_guarantee_exam.id
        sb_guarantee_exam.update(status: Status::ExamStatus::COMPANY_NOT_DETECTED )
        entity_id = Entity.all.first.id
        SbGuaranteeClient.where(id: sb_guarantee_exam.sb_guarantee_client_id).update_all(entity_id: entity_id)
        SbGuaranteeCustomer.where(id: sb_guarantee_exam.sb_guarantee_customer_id).update_all(entity_id: nil)

        identify_company.assign_entity(Entity.find entity_id)

        expect(SbGuaranteeExam.find(sb_guarantee_exam.id).status_id).to eq Status::ExamStatus::READY_FOR_EXAM.id
      end
    end

  end

  describe "データ登録確認" do
    context "クライアント一覧からの企業新規登録" do
      let(:identify_company) { IdentifyCompanyForm.init("client", params_hash) }
      before {
        identify_company
        EntityProfile.delete_all
        Entity.delete_all
      }

      subject { -> {identify_company.create_entity} }
      it "Entityテーブルのレコードが１件が登録される" do
        is_expected.to change { Entity.all.size }.from(0).to(1)
      end
      it "EntityProfileテーブルのレコードが１件が登録される" do
        is_expected.to change { EntityProfile.all.size }.from(0).to(1)
      end
    end

    context "保証審査一覧（保証元）からの企業新規登録" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_client", params_hash) }
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      before {
        identify_company.id = sb_guarantee_exam.id
        EntityProfile.delete_all
        Entity.delete_all
      }

      subject { -> {identify_company.create_entity} }
      it "Entityテーブルのレコードが１件が登録される" do
        is_expected.to change { Entity.all.size }.from(0).to(1)
      end
      it "EntityProfileテーブルのレコードが１件が登録される" do
        is_expected.to change { EntityProfile.all.size }.from(0).to(1)
      end
    end

    context "保証審査一覧（保証先）からの企業新規登録" do
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_customer", params_hash) }
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      before {
        identify_company.id = sb_guarantee_exam.id
        EntityProfile.delete_all
        Entity.delete_all
      }

      subject { -> {identify_company.create_entity} }
      it "Entityテーブルのレコードが１件が登録される" do
        is_expected.to change { Entity.all.size }.from(0).to(1)
      end
      it "EntityProfileテーブルのレコードが１件が登録される" do
        is_expected.to change { EntityProfile.all.size }.from(0).to(1)
      end
    end
  end
end
