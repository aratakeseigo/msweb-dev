require "rails_helper"

RSpec.describe IdentifyCompanyForm, type: :model do
  let(:internal_user) { create :internal_user }
  let(:entity) { create :entity }
  let(:sb_client) { create :sb_client }
  let(:params_hash) {
    {
      "classification" => "1",
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
  let(:identify_company) { IdentifyCompanyForm.init("1", params_hash) }
  describe "バリデーション" do

    context "全て正常場合" do
      it "有効である" do
          expect(identify_company).not_to be_invalid
      end
    end
  end

  describe "起動元区分確認" do
    context "クライアント一覧（classification => '1'）" do
      it "インスタンスがIdentifyCompanyForm::Clientである" do
        expect(identify_company.instance_of?(IdentifyCompanyForm::Client)).to eq(true)
      end
    end
  end

  describe "データ更新確認" do
    context "クライアント一覧からのステータス更新" do

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
  end

  describe "データ登録確認" do
      context "企業新規登録" do
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
  