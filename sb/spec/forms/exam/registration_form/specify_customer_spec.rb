require "rails_helper"

RSpec.describe Exam::RegistrationForm, type: :model do
  describe "保証先の特定" do
    let(:internal_user) { create :internal_user }
    let(:sb_client) { create :sb_client }
    let(:exam_form) { Exam::RegistrationForm.new(sb_client, internal_user) }
    let!(:customer) { create :sb_guarantee_customer }
    context "既存の保証先と企業名と代表者名で一致した場合" do
      let(:res) {
        exam_form.specify_customer({
          "company_name" => customer.company_name,
          "daihyo_name" => customer.daihyo_name,
          "taxagency_corporate_number" => nil,
          "address" => nil,
        })
      }
      it "既存の保証先が返却される" do
        expect(res).to eq customer
      end
      it "extityは増えない" do
        expect { res }.to change { Entity.count }.by(0)
      end
      it "SbGuaranteeCustomerが増えない" do
        expect { res.save }.to change { SbGuaranteeCustomer.count }.by(0)
      end
    end
    context "既存の保証先と法人番号と住所(町名まで)で一致した場合" do
      let(:res) {
        exam_form.specify_customer({
          "company_name" => nil,
          "daihyo_name" => nil,
          "taxagency_corporate_number" => customer.taxagency_corporate_number,
          "prefecture" => customer.prefecture,
          "address" => customer.address,
        })
      }
      it "既存の保証先が返却される" do
        expect(res).to eq customer
      end
      it "extityは増えない" do
        expect { res }.to change { Entity.count }.by(0)
      end
      it "SbGuaranteeCustomerが増えない" do
        expect { res.save }.to change { SbGuaranteeCustomer.count }.by(0)
      end
    end
    describe "新規保証先の作成" do
      let!(:entity) { create :entity }
      context "法人情報と一致した場合" do
        let(:res) {
          exam_form.specify_customer({
            "company_name" => entity.entity_profile.corporation_name,
            "daihyo_name" => entity.entity_profile.daihyo_name,
            "taxagency_corporate_number" => nil,
            "address" => nil,
          })
        }
        it "新規の保証先に既存のEntityが設定されて返却される" do
          expect(res.entity).to eq entity
          expect(res.company_name).to eq entity.entity_profile.corporation_name
          expect(res.daihyo_name).to eq entity.entity_profile.daihyo_name
        end
        it "extityは増えない" do
          expect { res }.to change { Entity.count }.by(0)
        end
        it "SbGuaranteeCustomerが増える" do
          expect { res.save }.to change { SbGuaranteeCustomer.count }.by(1)
        end
      end
      context "法人情報と一致しなかった場合" do
        # dbには保存せずに値を取得するために初期化
        let!(:other_customer) { build :sb_guarantee_customer, :other_customer }
        let(:res) {
          exam_form.specify_customer({
            "company_name" => other_customer.company_name,
            "daihyo_name" => other_customer.daihyo_name,
            "taxagency_corporate_number" => nil,
            "address" => nil,
          })
        }
        it "新規の保証先に新規Entityが設定されて返却される" do
          expect(res.company_name).to eq other_customer.company_name
          expect(res.daihyo_name).to eq other_customer.daihyo_name
          expect(res.entity_id).to be_present
        end
        it "extityが増える" do
          expect { res }.to change { Entity.count }.by(1)
          expect(res.entity.entity_profile.corporation_name).to eq other_customer.company_name
          expect(res.entity.entity_profile.daihyo_name).to eq other_customer.daihyo_name
        end
        it "SbGuaranteeCustomerが増える" do
          expect { res.save }.to change { SbGuaranteeCustomer.count }.by(1)
        end
      end
      context "法人情報に候補が存在した場合" do
        let(:res) {
          # 会社名だけ一致
          exam_form.specify_customer({
            "company_name" => entity.entity_profile.corporation_name,
            "daihyo_name" => "柿谷　曜一朗",
            "taxagency_corporate_number" => nil,
            "address" => nil,
          })
        }
        it "新規の保証先にEntityが設定されずに返却される" do
          expect(res.company_name).to eq entity.entity_profile.corporation_name
          expect(res.daihyo_name).to eq "柿谷　曜一朗"
          expect(res.entity_id).to be_nil
        end
        it "extityが増ない" do
          expect { res }.to change { Entity.count }.by(0)
        end
        it "SbGuaranteeCustomerが増える" do
          expect { res.save }.to change { SbGuaranteeCustomer.count }.by(1)
        end
      end
    end
  end
end
