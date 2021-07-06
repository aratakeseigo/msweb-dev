require "rails_helper"

RSpec.describe SbGuarantee, type: :model do
  context "バリデーション(必須)" do
    context "会社名が空の場合" do
      let(:sb_guarantee) { build :sb_guarantee, company_name: nil }
      it "無効である" do
        expect(sb_guarantee).to be_invalid
      end
    end
    context "代表者名が空の場合" do
      let(:sb_guarantee) { build :sb_guarantee, daihyo_name: nil }
      it "無効である" do
        expect(sb_guarantee).to be_invalid
      end
    end
  end

  context "バリデーション(長さ)" do
    context "企業名が256文字以上の場合" do
      let(:sb_guarantee_ok) { build :sb_guarantee, company_name: "あ" * 255 }
      it "有効である" do
        expect(sb_guarantee_ok).to be_valid
      end
      let(:sb_guarantee_ng) { build :sb_guarantee, company_name: "あ" * 256 }
      it "無効である" do
        expect(sb_guarantee_ng).to be_invalid
      end
    end

    context "代表者にスペースが含まれない場合" do
      let(:sb_guarantee_ok) { build :sb_guarantee, daihyo_name: "あ" * 255 }
      it "無効である" do
        expect(sb_guarantee_ok).to be_invalid
      end
    end

    context "代表者が256文字以上の場合" do
      let(:sb_guarantee_ok) { build :sb_guarantee, daihyo_name: "あ" * 127 + "　" + "あ" * 127 }
      it "有効である" do
        expect(sb_guarantee_ok).to be_valid
      end
      let(:sb_guarantee_ng) { build :sb_guarantee, daihyo_name: "あ" * 127 + "　" + "あ" * 128 }
      it "無効である" do
        expect(sb_guarantee_ng).to be_invalid
      end
    end
    context "クライアント企業名が256文字以上の場合" do
      let(:sb_guarantee_ok) { build :sb_guarantee, client_company_name: "あ" * 255 }
      it "有効である" do
        expect(sb_guarantee_ok).to be_valid
      end
      let(:sb_guarantee_ng) { build :sb_guarantee, client_company_name: "あ" * 256 }
      it "無効である" do
        expect(sb_guarantee_ng).to be_invalid
      end
    end

    context "クライアント代表者にスペースが含まれない場合" do
      let(:sb_guarantee_ok) { build :sb_guarantee, client_daihyo_name: "あ" * 255 }
      it "無効である" do
        expect(sb_guarantee_ok).to be_invalid
      end
    end

    context "クライアント代表者が256文字以上の場合" do
      let(:sb_guarantee_ok) { build :sb_guarantee, client_daihyo_name: "あ" * 127 + "　" + "あ" * 127 }
      it "有効である" do
        expect(sb_guarantee_ok).to be_valid
      end
      let(:sb_guarantee_ng) { build :sb_guarantee, client_daihyo_name: "あ" * 127 + "　" + "あ" * 128 }
      it "無効である" do
        expect(sb_guarantee_ng).to be_invalid
      end
    end
  end
end
