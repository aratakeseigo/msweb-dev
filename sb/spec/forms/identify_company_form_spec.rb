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

  describe "リダイレクトパス" do
    let(:identify_company1) { IdentifyCompanyForm.init("client", params_hash) }
    context "クライアント一覧のパスが取得できる" do
      it "/clients/listが取得できる" do
        expect(identify_company1.redirect_path).to eq "/clients/list"
      end
    end
    let(:identify_company2) { IdentifyCompanyForm.init("guarantee_client", params_hash) }
    context "保証審査一覧（保障元）のパスが取得できる" do
      it "/examsが取得できる" do
        expect(identify_company2.redirect_path).to eq "/exams"
      end
    end
    let(:identify_company3) { IdentifyCompanyForm.init("guarantee_customer", params_hash) }
    context "保証審査一覧（保障先）のパスが取得できる" do
      it "/examsが取得できる" do
        expect(identify_company3.redirect_path).to eq "/exams"
      end
    end
  end

  describe "例外の場合" do
    context "区分が未定義" do
      it "request errorの例外が発生する" do
        expect{IdentifyCompanyForm.init("aaaa", params_hash)}.to raise_error("request error")
      end
    end
    context "redirect_pathが未定義" do
      let(:identify_company) { IdentifyCompanyForm.new }
      it "サブクラスで実装してくださいの例外が発生する" do
        expect{identify_company.redirect_path}.to raise_error("サブクラスで実装してください")
      end
      it "サブクラスで実装してくださいの例外が発生する" do
        expect{identify_company.assign_default_values}.to raise_error("サブクラスで実装してください")
      end
      it "サブクラスで実装してくださいの例外が発生する" do
        expect{identify_company.assign_entity(1)}.to raise_error("サブクラスで実装してください")
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

  describe "特定対象を既存企業から取得する" do
    context "クライアント一覧からの企業情報取得" do
      let(:sb_client) { create :sb_client }
      let(:identify_company) { IdentifyCompanyForm.init("client", params_hash) }
      before {
        identify_company.company_name = nil
        identify_company.daihyo_name = nil
        identify_company.taxagency_corporate_number = nil
        identify_company.prefecture_code = nil
        identify_company.address = nil
        identify_company.daihyo_tel = nil
        identify_company.established = nil
        identify_company.zip_code = nil
        identify_company.id = sb_client.id
        identify_company.assign_default_values
      }
      it "各項目が設定される" do
        expect( identify_company.company_name).to eq  sb_client.name
        expect( identify_company.daihyo_name ).to eq  sb_client.daihyo_name
        expect( identify_company.taxagency_corporate_number ).to eq  sb_client.taxagency_corporate_number
        expect( identify_company.prefecture_code ).to eq  sb_client.prefecture_code
        expect( identify_company.address ).to eq  sb_client.address
        expect( identify_company.daihyo_tel ).to eq  sb_client.tel
        expect( identify_company.established ).to eq  sb_client.established_in
        expect( identify_company.zip_code  ).to eq  sb_client.zip_code
      end
    end
    context "保証審査一覧（保障元）からの企業情報取得" do
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_client", params_hash) }
      before {
        identify_company.company_name = nil
        identify_company.daihyo_name = nil
        identify_company.taxagency_corporate_number = nil
        identify_company.prefecture_code = nil
        identify_company.address = nil
        identify_company.daihyo_tel = nil
        identify_company.established = nil
        identify_company.zip_code = nil
        identify_company.id = sb_guarantee_exam.id
        identify_company.assign_default_values
        @guarantee_client = SbGuaranteeClient.find(sb_guarantee_exam.sb_guarantee_client_id)
      }
      it "各項目が設定される" do
        expect( identify_company.company_name).to eq  @guarantee_client.company_name
        expect( identify_company.daihyo_name ).to eq  @guarantee_client.daihyo_name
        expect( identify_company.taxagency_corporate_number ).to eq  @guarantee_client.taxagency_corporate_number
        expect( identify_company.prefecture_code ).to eq  @guarantee_client.prefecture_code
        expect( identify_company.address ).to eq  @guarantee_client.address
        expect( identify_company.daihyo_tel ).to eq  @guarantee_client.tel
      end
    end
    context "保証審査一覧（保障先）からの企業情報取得" do
      let(:sb_guarantee_exam) { create :sb_guarantee_exam }
      let(:identify_company) { IdentifyCompanyForm.init("guarantee_customer", params_hash) }
      before {
        identify_company.company_name = nil
        identify_company.daihyo_name = nil
        identify_company.taxagency_corporate_number = nil
        identify_company.prefecture_code = nil
        identify_company.address = nil
        identify_company.daihyo_tel = nil
        identify_company.established = nil
        identify_company.zip_code = nil
        identify_company.id = sb_guarantee_exam.id
        identify_company.assign_default_values
        @guarantee_customer = SbGuaranteeCustomer.find(sb_guarantee_exam.sb_guarantee_customer_id)
      }
      it "各項目が設定される" do
        expect( identify_company.company_name).to eq  @guarantee_customer.company_name
        expect( identify_company.daihyo_name ).to eq  @guarantee_customer.daihyo_name
        expect( identify_company.taxagency_corporate_number ).to eq  @guarantee_customer.taxagency_corporate_number
        expect( identify_company.prefecture_code ).to eq  @guarantee_customer.prefecture_code
        expect( identify_company.address ).to eq  @guarantee_customer.address
        expect( identify_company.daihyo_tel ).to eq  @guarantee_customer.tel
      end
    end

  end

end
