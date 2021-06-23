require "rails_helper"

RSpec.describe SbGuaranteeClient, type: :model do
  context "バリデーション(tel_validator)" do
    context "電話番号に数字以外が混ざっている場合" do
      let(:sb_guarantee_client) { build :sb_guarantee_client, tel: "1234S678901" }
      it "無効である" do
        expect(sb_guarantee_client).to be_invalid
      end
    end
    context "電話番号が10or11桁でない場合" do
      let(:sb_guarantee_client_12) { build :sb_guarantee_client, tel: "123456789012" }
      it "無効である" do
        expect(sb_guarantee_client_12).to be_invalid
      end
      let(:sb_guarantee_client_11) { build :sb_guarantee_client, tel: "12345678901" }
      it "有効である" do
        expect(sb_guarantee_client_11).to be_valid
      end
      let(:sb_guarantee_client_10) { build :sb_guarantee_client, tel: "1234567890" }
      it "有効である" do
        expect(sb_guarantee_client_10).to be_valid
      end
      let(:sb_guarantee_client_9) { build :sb_guarantee_client, tel: "123456789" }
      it "無効である" do
        expect(sb_guarantee_client_9).to be_invalid
      end
    end
  end

  context "バリデーション(taxagency_corporate_number_validator)" do
    context "法人番号に数字以外が混ざっている場合" do
      let(:sb_guarantee_client) { build :sb_guarantee_client, taxagency_corporate_number: "1234S6789o123" }
      it "無効である" do
        expect(sb_guarantee_client).to be_invalid
      end
    end
    context "法人番号が13桁でない場合" do
      let(:sb_guarantee_client_14) { build :sb_guarantee_client, taxagency_corporate_number: "12345678901234" }
      it "無効である" do
        expect(sb_guarantee_client_14).to be_invalid
      end
      let(:sb_guarantee_client_13) { build :sb_guarantee_client, taxagency_corporate_number: "1234567890123" }
      it "有効である" do
        expect(sb_guarantee_client_13).to be_valid
      end
      let(:sb_guarantee_client_12) { build :sb_guarantee_client, taxagency_corporate_number: "123456789012" }
      it "無効である" do
        expect(sb_guarantee_client_12).to be_invalid
      end
    end
  end

  context "バリデーション(長さ)" do
    context "企業名が256文字以上の場合" do
      let(:sb_guarantee_client_ok) { build :sb_guarantee_client, company_name: "あ" * 255 }
      it "有効である" do
        expect(sb_guarantee_client_ok).to be_valid
      end
      let(:sb_guarantee_client_ng) { build :sb_guarantee_client, company_name: "あ" * 256 }
      it "無効である" do
        expect(sb_guarantee_client_ng).to be_invalid
      end
    end

    context "代表者にスペースが含まれない場合" do
      let(:sb_guarantee_client_ok) { build :sb_guarantee_client, daihyo_name: "あ" * 255 }
      it "無効である" do
        expect(sb_guarantee_client_ok).to be_invalid
      end
    end

    context "代表者が256文字以上の場合" do
      let(:sb_guarantee_client_ok) { build :sb_guarantee_client, daihyo_name: "あ" * 127 + "　" + "あ" * 127 }
      it "有効である" do
        expect(sb_guarantee_client_ok).to be_valid
      end
      let(:sb_guarantee_client_ng) { build :sb_guarantee_client, daihyo_name: "あ" * 127 + "　" + "あ" * 128 }
      it "無効である" do
        expect(sb_guarantee_client_ng).to be_invalid
      end
    end

    context "住所が256文字以上の場合" do
      let(:sb_guarantee_client_ok) { build :sb_guarantee_client, address: "あ" * 255 }
      it "有効である" do
        expect(sb_guarantee_client_ok).to be_valid
      end
      let(:sb_guarantee_client_ng) { build :sb_guarantee_client, address: "あ" * 256 }
      it "無効である" do
        expect(sb_guarantee_client_ng).to be_invalid
      end
    end
  end

  describe "保証元の特定" do
    let(:internal_user) { create :internal_user }
    let!(:entity) { create :entity }
    let!(:sb_client) { create :sb_client, entity: entity }
    context "保証元情報にクライアント自身を設定する" do
      context "クライアントがまだ保証元として登録されていない場合" do
        let(:res) {
          SbGuaranteeClient.assign_client_myself(sb_client)
        }
        it "クライアントを保証元として返却する" do
          expect(res.entity).to eq sb_client.entity
        end
        it "SbGuaranteeClientが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
      context "クライアントがすでに保証元として登録されている場合" do
        let!(:grt_client_myself) { create :sb_guarantee_client, sb_client: sb_client, entity: sb_client.entity }
        let(:res) {
          SbGuaranteeClient.assign_client_myself(sb_client)
        }

        it "既存の保証元を返却する" do
          expect(res.entity).to eq sb_client.entity
          expect(res.entity).to eq grt_client_myself.entity
        end
        it "SbGuaranteeClientが増えない" do
          expect { res.save }.to change { SbGuaranteeClient.count }.by(0)
        end
      end
    end

    context "クライアントがもつ既存の保証元と企業名と代表者名で一致した場合" do
      let!(:grt_client) { create :sb_guarantee_client, sb_client: sb_client }
      let(:res) {
        SbGuaranteeClient.assign_client(sb_client,
                                        company_name: grt_client.company_name,
                                        daihyo_name: grt_client.daihyo_name,
                                        taxagency_corporate_number: nil,
                                        address: nil)
      }
      it "既存の保証先が返却される" do
        expect(res).to eq grt_client
      end
      it "extityは増えない" do
        expect { res }.to change { Entity.count }.by(0)
      end
      it "SbGuaranteeClientが増えない" do
        expect { res.save }.to change { SbGuaranteeClient.count }.by(0)
      end
    end
    context "クライアントがもつ既存の保証元と法人番号と住所(町名まで)で一致した場合" do
      let!(:grt_client) { create :sb_guarantee_client, sb_client: sb_client }
      let(:res) {
        SbGuaranteeClient.assign_client(sb_client,
                                        company_name: grt_client.company_name + "東京",
                                        daihyo_name: grt_client.daihyo_name + "　闘莉王",
                                        taxagency_corporate_number: grt_client.taxagency_corporate_number,
                                        prefecture: grt_client.prefecture,
                                        address: grt_client.address)
      }
      it "既存の保証先が返却される" do
        expect(res).to eq grt_client
      end
      it "extityは増えない" do
        expect { res }.to change { Entity.count }.by(0)
      end
      it "SbGuaranteeClientが増えない" do
        expect { res.save }.to change { SbGuaranteeClient.count }.by(0)
      end
    end
    context "他のクライアントがもつ既存の保証元と一致した場合" do
      let(:entity_other) { create :entity }
      let!(:sb_client_other) { create :sb_client, entity: entity_other }
      let!(:grt_client) { create :sb_guarantee_client, sb_client: sb_client_other }
      context "企業名と代表者名で一致した場合" do
        let(:res) {
          SbGuaranteeClient.assign_client(sb_client,
                                          company_name: grt_client.company_name,
                                          daihyo_name: grt_client.daihyo_name,
                                          taxagency_corporate_number: nil,
                                          address: nil)
        }

        it "既存の保証元は返却されない" do
          expect(res).not_to eq grt_client
        end
        it "SbGuaranteeClientが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
      context "法人番号と住所(町名まで)で一致した場合" do
        let(:res) {
          SbGuaranteeClient.assign_client(sb_client,
                                          company_name: grt_client.company_name + "　ロンドン支局",
                                          daihyo_name: grt_client.daihyo_name + "　チマ",
                                          taxagency_corporate_number: grt_client.taxagency_corporate_number,
                                          prefecture: grt_client.prefecture,
                                          address: grt_client.address)
        }

        it "既存の保証元は返却されない" do
          expect(res).not_to eq grt_client
        end
        it "SbGuaranteeClientが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
    end
    describe "新規保証元の作成" do
      context "法人情報と一致した場合" do
        let(:res) {
          SbGuaranteeClient.assign_client(sb_client,
                                          company_name: entity.entity_profile.corporation_name,
                                          daihyo_name: entity.entity_profile.daihyo_name,
                                          taxagency_corporate_number: nil,
                                          address: nil)
        }
        it "新規の保証元に既存のEntityが設定されて返却される" do
          expect(res.entity).to eq entity
          expect(res.company_name).to eq entity.entity_profile.corporation_name
          expect(res.daihyo_name).to eq entity.entity_profile.daihyo_name
        end
        it "extityは増えない" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { Entity.count }.by(0)
        end
        it "SbGuaranteeClientが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
      context "法人情報と一致しなかった場合" do
        # dbには保存せずに値を取得するために初期化
        let!(:other_customer) { build :sb_guarantee_customer, :other_customer }
        let(:res) {
          SbGuaranteeClient.assign_client(sb_client,
                                          company_name: other_customer.company_name,
                                          daihyo_name: other_customer.daihyo_name,
                                          taxagency_corporate_number: nil,
                                          address: nil)
        }
        it "新規の保証元に新規のEntityが設定されて返却される" do
          expect(res.company_name).to eq other_customer.company_name
          expect(res.daihyo_name).to eq other_customer.daihyo_name
          expect(res.entity).to be_present
        end
        it "extityが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { Entity.count }.by(1)
          expect(res.entity.entity_profile.corporation_name).to eq other_customer.company_name
          expect(res.entity.entity_profile.daihyo_name).to eq other_customer.daihyo_name
        end
        it "SbGuaranteeClientが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
      context "法人情報に候補が存在した場合" do
        let(:res) {
          # 代表者名だけ一致
          SbGuaranteeClient.assign_client(sb_client,
                                          company_name: "株式会社セレッソ",
                                          daihyo_name: entity.entity_profile.daihyo_name,
                                          taxagency_corporate_number: nil,
                                          address: nil)
        }

        it "新規の保証元にEntityが設定されずに返却される" do
          expect(res.company_name).to eq "株式会社セレッソ"
          expect(res.daihyo_name).to eq entity.entity_profile.daihyo_name
          expect(res.entity_id).to be_nil
        end
        it "extityは増えない" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { Entity.count }.by(0)
        end
        it "SbGuaranteeClientが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
    end
  end
end
