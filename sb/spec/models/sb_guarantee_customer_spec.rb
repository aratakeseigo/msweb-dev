require "rails_helper"

RSpec.describe SbGuaranteeCustomer, type: :model do
  context "バリデーション(tel_validator)" do
    context "電話番号に数字以外が混ざっている場合" do
      let(:sb_guarantee_customer) { build :sb_guarantee_customer, tel: "1234S678901" }
      it "無効である" do
        expect(sb_guarantee_customer).to be_invalid
      end
    end
    context "電話番号が10or11桁でない場合" do
      let(:sb_guarantee_customer_12) { build :sb_guarantee_customer, tel: "123456789012" }
      it "無効である" do
        expect(sb_guarantee_customer_12).to be_invalid
      end
      let(:sb_guarantee_customer_11) { build :sb_guarantee_customer, tel: "12345678901" }
      it "有効である" do
        expect(sb_guarantee_customer_11).to be_valid
      end
      let(:sb_guarantee_customer_10) { build :sb_guarantee_customer, tel: "1234567890" }
      it "有効である" do
        expect(sb_guarantee_customer_10).to be_valid
      end
      let(:sb_guarantee_customer_9) { build :sb_guarantee_customer, tel: "123456789" }
      it "無効である" do
        expect(sb_guarantee_customer_9).to be_invalid
      end
    end
  end

  context "バリデーション(taxagency_corporate_number_validator)" do
    context "法人番号に数字以外が混ざっている場合" do
      let(:sb_guarantee_customer) { build :sb_guarantee_customer, taxagency_corporate_number: "1234S6789o123" }
      it "無効である" do
        expect(sb_guarantee_customer).to be_invalid
      end
    end
    context "法人番号が13桁でない場合" do
      let(:sb_guarantee_customer_14) { build :sb_guarantee_customer, taxagency_corporate_number: "12345678901234" }
      it "無効である" do
        expect(sb_guarantee_customer_14).to be_invalid
      end
      let(:sb_guarantee_customer_13) { build :sb_guarantee_customer, taxagency_corporate_number: "1234567890123" }
      it "有効である" do
        expect(sb_guarantee_customer_13).to be_valid
      end
      let(:sb_guarantee_customer_12) { build :sb_guarantee_customer, taxagency_corporate_number: "123456789012" }
      it "無効である" do
        expect(sb_guarantee_customer_12).to be_invalid
      end
    end
  end

  context "バリデーション(長さ)" do
    context "企業名が256文字以上の場合" do
      let(:sb_guarantee_customer_ok) { build :sb_guarantee_customer, company_name: "あ" * 255 }
      it "有効である" do
        expect(sb_guarantee_customer_ok).to be_valid
      end
      let(:sb_guarantee_customer_ng) { build :sb_guarantee_customer, company_name: "あ" * 256 }
      it "無効である" do
        expect(sb_guarantee_customer_ng).to be_invalid
      end
    end

    context "代表者にスペースが含まれない場合" do
      let(:sb_guarantee_customer_ok) { build :sb_guarantee_customer, daihyo_name: "あ" * 255 }
      it "無効である" do
        expect(sb_guarantee_customer_ok).to be_invalid
      end
    end

    context "代表者が256文字以上の場合" do
      let(:sb_guarantee_customer_ok) { build :sb_guarantee_customer, daihyo_name: "あ" * 127 + "　" + "あ" * 127 }
      it "有効である" do
        expect(sb_guarantee_customer_ok).to be_valid
      end
      let(:sb_guarantee_customer_ng) { build :sb_guarantee_customer, daihyo_name: "あ" * 127 + "　" + "あ" * 128 }
      it "無効である" do
        expect(sb_guarantee_customer_ng).to be_invalid
      end
    end

    context "住所が256文字以上の場合" do
      let(:sb_guarantee_customer_ok) { build :sb_guarantee_customer, address: "あ" * 255 }
      it "有効である" do
        expect(sb_guarantee_customer_ok).to be_valid
      end
      let(:sb_guarantee_customer_ng) { build :sb_guarantee_customer, address: "あ" * 256 }
      it "無効である" do
        expect(sb_guarantee_customer_ng).to be_invalid
      end
    end
  end
  describe "保証先の特定" do
    let(:internal_user) { create :internal_user }
    let(:sb_client) { create :sb_client }
    let!(:customer) { create :sb_guarantee_customer }
    context "既存の保証先と企業名と代表者名で一致した場合" do
      let(:res) {
        SbGuaranteeCustomer.assign_customer(
          company_name: customer.company_name,
          daihyo_name: customer.daihyo_name,
          taxagency_corporate_number: nil,
          address: nil,
        )
      }
      it "既存の保証先が返却される" do
        expect(res).to eq customer
      end
      it "extityは増えない" do
        expect { res.save }.to change { Entity.count }.by(0)
      end
      it "SbGuaranteeCustomerが増えない" do
        expect {
          res.created_user = internal_user
          res.save
        }.to change { SbGuaranteeCustomer.count }.by(0)
      end
    end
    context "既存の保証先と法人番号と住所(町名まで)で一致した場合" do
      let(:res) {
        SbGuaranteeCustomer.assign_customer(
          company_name: nil,
          daihyo_name: nil,
          taxagency_corporate_number: customer.taxagency_corporate_number,
          prefecture: customer.prefecture,
          address: customer.address,
        )
      }
      it "既存の保証先が返却される" do
        expect(res).to eq customer
      end
      it "extityは増えない" do
        expect { res.save }.to change { Entity.count }.by(0)
      end
      it "SbGuaranteeCustomerが増えない" do
        expect {
          res.created_user = internal_user
          res.save
        }.to change { SbGuaranteeCustomer.count }.by(0)
      end
    end
    describe "新規保証先の作成" do
      let!(:entity) { create :entity }
      context "法人情報と一致した場合" do
        let(:res) {
          SbGuaranteeCustomer.assign_customer(
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: entity.entity_profile.daihyo_name,
            taxagency_corporate_number: nil,
            address: nil,
          )
        }
        it "新規の保証先に既存のEntityが設定されて返却される" do
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
        it "SbGuaranteeCustomerが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeCustomer.count }.by(1)
        end
      end
      context "法人情報と一致しなかった場合" do
        # dbには保存せずに値を取得するために初期化
        let!(:other_customer) { build :sb_guarantee_customer, :other_customer }
        let(:res) {
          SbGuaranteeCustomer.assign_customer(
            company_name: other_customer.company_name,
            daihyo_name: other_customer.daihyo_name,
            taxagency_corporate_number: nil,
            address: nil,
          )
        }
        it "新規の保証先に新規Entityが設定されて返却される" do
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
        it "SbGuaranteeCustomerが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeCustomer.count }.by(1)
        end
      end
      context "法人情報に候補が存在した場合" do
        let(:res) {
          # 会社名だけ一致
          SbGuaranteeCustomer.assign_customer(
            company_name: entity.entity_profile.corporation_name,
            daihyo_name: "柿谷　曜一朗",
            taxagency_corporate_number: nil,
            address: nil,
          )
        }
        it "新規の保証先にEntityが設定されずに返却される" do
          expect(res.company_name).to eq entity.entity_profile.corporation_name
          expect(res.daihyo_name).to eq "柿谷　曜一朗"
          expect(res.entity_id).to be_nil
        end
        it "extityが増ない" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { Entity.count }.by(0)
        end
        it "SbGuaranteeCustomerが増える" do
          expect {
            res.created_user = internal_user
            res.save
          }.to change { SbGuaranteeCustomer.count }.by(1)
        end
      end
    end
  end
end
