require "rails_helper"

RSpec.describe Exam::RegistrationForm, type: :model do
  describe "保証元の特定" do
    let(:internal_user) { create :internal_user }
    let!(:entity) { create :entity }
    let!(:sb_client) { create :sb_client, entity: entity }
    let(:exam_form) { Exam::RegistrationForm.new(sb_client, internal_user) }
    context "保証元情報が存在しない場合" do
      context "クライアントがまだ保証元として登録されていない場合" do
        let(:res) {
          exam_form.specify_client({
            "cl_company_name" => nil,
            "cl_daihyo_name" => nil,
            "cl_taxagency_corporate_number" => nil,
            "cl_address" => nil,
          })
        }
        it "クライアントを保証元として保存して返却する" do
          expect(res.entity).to eq sb_client.entity
        end
        it "SbGuaranteeClientが増える" do
          expect { res.save }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
      context "クライアントがすでに保証元として登録されている場合" do
        let!(:grt_client_myself) { create :sb_guarantee_client, sb_client: sb_client, entity: sb_client.entity }
        let(:res) {
          exam_form.specify_client({
            "cl_company_name" => nil,
            "cl_daihyo_name" => nil,
            "cl_taxagency_corporate_number" => nil,
            "cl_address" => nil,
          })
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
        exam_form.specify_client({
          "cl_company_name" => grt_client.company_name,
          "cl_daihyo_name" => grt_client.daihyo_name,
          "cl_taxagency_corporate_number" => nil,
          "cl_address" => nil,
        })
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
        exam_form.specify_client({
          "cl_company_name" => grt_client.company_name + "東京",
          "cl_daihyo_name" => grt_client.daihyo_name + "　闘莉王",
          "cl_taxagency_corporate_number" => grt_client.taxagency_corporate_number,
          "prefecture" => grt_client.prefecture,
          "address" => grt_client.address,
        })
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
          exam_form.specify_client({
            "cl_company_name" => grt_client.company_name,
            "cl_daihyo_name" => grt_client.daihyo_name,
            "cl_taxagency_corporate_number" => nil,
            "cl_address" => nil,
          })
        }

        it "既存の保証元は返却されない" do
          expect(res).not_to eq grt_client
        end
        it "SbGuaranteeClientが増える" do
          expect { res.save }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
      context "法人番号と住所(町名まで)で一致した場合" do
        let(:res) {
          exam_form.specify_client({
            "cl_company_name" => grt_client.company_name + "　ロンドン支局",
            "cl_daihyo_name" => grt_client.daihyo_name + "　チマ",
            "cl_taxagency_corporate_number" => grt_client.taxagency_corporate_number,
            "prefecture" => grt_client.prefecture,
            "address" => grt_client.address,
          })
        }

        it "既存の保証元は返却されない" do
          expect(res).not_to eq grt_client
        end
        it "SbGuaranteeClientが増える" do
          expect { res.save }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
    end
    describe "新規保証元の作成" do
      context "法人情報と一致した場合" do
        let(:res) {
          exam_form.specify_client({
            "cl_company_name" => entity.entity_profile.corporation_name,
            "cl_daihyo_name" => entity.entity_profile.daihyo_name,
            "cl_taxagency_corporate_number" => nil,
            "cl_address" => nil,
          })
        }
        it "新規の保証元に既存のEntityが設定されて返却される" do
          expect(res.entity).to eq entity
          expect(res.company_name).to eq entity.entity_profile.corporation_name
          expect(res.daihyo_name).to eq entity.entity_profile.daihyo_name
        end
        it "extityは増えない" do
          expect { res }.to change { Entity.count }.by(0)
        end
        it "SbGuaranteeClientが増える" do
          expect { res.save }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
      context "法人情報と一致しなかった場合" do
        # dbには保存せずに値を取得するために初期化
        let!(:other_customer) { build :sb_guarantee_customer, :other_customer }
        let(:res) {
          exam_form.specify_client({
            "cl_company_name" => other_customer.company_name,
            "cl_daihyo_name" => other_customer.daihyo_name,
            "cl_taxagency_corporate_number" => nil,
            "cl_address" => nil,
          })
        }
        it "新規の保証元に新規のEntityが設定されて返却される" do
          expect(res.company_name).to eq other_customer.company_name
          expect(res.daihyo_name).to eq other_customer.daihyo_name
          expect(res.entity_id).to be_present
        end
        it "extityが増える" do
          expect { res }.to change { Entity.count }.by(1)
          expect(res.entity.entity_profile.corporation_name).to eq other_customer.company_name
          expect(res.entity.entity_profile.daihyo_name).to eq other_customer.daihyo_name
        end
        it "SbGuaranteeClientが増える" do
          expect { res.save }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
      context "法人情報に候補が存在した場合" do
        let(:res) {
          # 代表者名だけ一致
          exam_form.specify_client({
            "cl_company_name" => "株式会社セレッソ",
            "cl_daihyo_name" => entity.entity_profile.daihyo_name,
            "cl_taxagency_corporate_number" => nil,
            "cl_address" => nil,
          })
        }

        it "新規の保証元にEntityが設定されずに返却される" do
          expect(res.company_name).to eq "株式会社セレッソ"
          expect(res.daihyo_name).to eq entity.entity_profile.daihyo_name
          expect(res.entity_id).to be_nil
        end
        it "extityは増えない" do
          expect { res }.to change { Entity.count }.by(0)
        end
        it "SbGuaranteeClientが増える" do
          expect { res.save }.to change { SbGuaranteeClient.count }.by(1)
        end
      end
    end
  end
end
