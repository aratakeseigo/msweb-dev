require "rails_helper"

RSpec.describe SbClient, type: :model do
  context "バリデーション(zip_code_validator)" do
    context "郵便番号に数字以外が混ざっている場合" do
      let(:sb_client) { build :sb_client, zip_code: "123a111" }
      it "無効である" do
        expect(sb_client).to be_invalid
      end
    end
    context "郵便番号が7桁でない場合" do
      let(:sb_client_8) { build :sb_client, zip_code: "12345678" }
      it "無効である" do
        expect(sb_client_8).to be_invalid
      end
      let(:sb_client_7) { build :sb_client, zip_code: "1234567" }
      it "無効である" do
        expect(sb_client_7).to be_valid
      end
      let(:sb_client_6) { build :sb_client, zip_code: "123456" }
      it "無効である" do
        expect(sb_client_6).to be_invalid
      end
    end
  end

  context "バリデーション(tel_validator)" do
    context "電話番号に数字以外が混ざっている場合" do
      let(:sb_client) { build :sb_client, tel: "1234S678901" }
      it "無効である" do
        expect(sb_client).to be_invalid
      end
    end
    context "郵便番号が10or11桁でない場合" do
      let(:sb_client_12) { build :sb_client, tel: "123456789012" }
      it "無効である" do
        expect(sb_client_12).to be_invalid
      end
      let(:sb_client_11) { build :sb_client, tel: "12345678901" }
      it "有効である" do
        expect(sb_client_11).to be_valid
      end
      let(:sb_client_10) { build :sb_client, tel: "1234567890" }
      it "有効である" do
        expect(sb_client_10).to be_valid
      end
      let(:sb_client_9) { build :sb_client, tel: "123456789" }
      it "無効である" do
        expect(sb_client_9).to be_invalid
      end
    end
  end

  context "バリデーション(yyyymm_validator)" do
    context "設立年月に数字以外が混ざっている場合" do
      let(:sb_client) { build :sb_client, established_in: "1234S6" }
      it "無効である" do
        expect(sb_client).to be_invalid
      end
    end
    context "設立年月が6桁でない場合" do
      let(:sb_client_7) { build :sb_client, established_in: "1234567" }
      it "無効である" do
        expect(sb_client_7).to be_invalid
      end
      let(:sb_client_6) { build :sb_client, established_in: "200101" }
      it "有効である" do
        expect(sb_client_6).to be_valid
      end
      let(:sb_client_5) { build :sb_client, established_in: "12345" }
      it "無効である" do
        expect(sb_client_5).to be_invalid
      end
    end
    context "設立年月の月が1..12でない場合" do
      let(:sb_client_00) { build :sb_client, established_in: "200100" }
      it "無効である" do
        expect(sb_client_00).to be_invalid
      end
      let(:sb_client_01) { build :sb_client, established_in: "200101" }
      it "有効である" do
        expect(sb_client_01).to be_valid
      end
      let(:sb_client_12) { build :sb_client, established_in: "200612" }
      it "有効である" do
        expect(sb_client_12).to be_valid
      end
      let(:sb_client_13) { build :sb_client, established_in: "200813" }
      it "無効である" do
        expect(sb_client_13).to be_invalid
      end
    end
    context "設立年月の年が1900より大きくない場合" do
      let(:sb_client_1900) { build :sb_client, established_in: "190001" }
      it "無効である" do
        expect(sb_client_1900).to be_invalid
      end
      let(:sb_client_1901) { build :sb_client, established_in: "190101" }
      it "有効である" do
        expect(sb_client_1901).to be_valid
      end
    end
  end

  context "バリデーション(長さ)" do
    context "企業名が256文字以上の場合" do
      let(:sb_client_ok) { build :sb_client, name: "あ" * 255 }
      it "有効である" do
        expect(sb_client_ok).to be_valid
      end
      let(:sb_client_ng) { build :sb_client, name: "あ" * 256 }
      it "無効である" do
        expect(sb_client_ng).to be_invalid
      end
    end

    context "代表者が256文字以上の場合" do
      let(:sb_client_ok) { build :sb_client, daihyo_name: "あ" * 255 }
      it "有効である" do
        expect(sb_client_ok).to be_valid
      end
      let(:sb_client_ng) { build :sb_client, daihyo_name: "あ" * 256 }
      it "無効である" do
        expect(sb_client_ng).to be_invalid
      end
    end

    context "住所が256文字以上の場合" do
      let(:sb_client_ok) { build :sb_client, address: "あ" * 255 }
      it "有効である" do
        expect(sb_client_ok).to be_valid
      end
      let(:sb_client_ng) { build :sb_client, address: "あ" * 256 }
      it "無効である" do
        expect(sb_client_ng).to be_invalid
      end
    end

    context "業種(補足)が256文字以上の場合" do
      let(:sb_client_ok) { build :sb_client, industry_optional: "あ" * 255 }
      it "有効である" do
        expect(sb_client_ok).to be_valid
      end
      let(:sb_client_ng) { build :sb_client, industry_optional: "あ" * 256 }
      it "無効である" do
        expect(sb_client_ng).to be_invalid
      end
    end
  end
end
