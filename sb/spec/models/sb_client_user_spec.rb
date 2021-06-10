require "rails_helper"

RSpec.describe SbClientUser, type: :model do
  context "バリデーション(長さ)" do
    context "担当者名が256文字以上の場合" do
      let(:sb_client_user_ok) { build :sb_client_user, name: "あ" * 255 }
      it "有効である" do
        expect(sb_client_user_ok).to be_valid
      end
      let(:sb_client_user_ng) { build :sb_client_user, name: "あ" * 256 }
      it "無効である" do
        expect(sb_client_user_ng).to be_invalid
      end
    end

    context "担当者名カナが256文字以上の場合" do
      let(:sb_client_user_ok) { build :sb_client_user, name_kana: "あ" * 255 }
      it "有効である" do
        expect(sb_client_user_ok).to be_valid
      end
      let(:sb_client_user_ng) { build :sb_client_user, name_kana: "あ" * 256 }
      it "無効である" do
        expect(sb_client_user_ng).to be_invalid
      end
    end

    context "役職が256文字以上の場合" do
      let(:sb_client_user_ok) { build :sb_client_user, position: "あ" * 255 }
      it "有効である" do
        expect(sb_client_user_ok).to be_valid
      end
      let(:sb_client_user_ng) { build :sb_client_user, position: "あ" * 256 }
      it "無効である" do
        expect(sb_client_user_ng).to be_invalid
      end
    end

    context "部署が256文字以上の場合" do
      let(:sb_client_user_ok) { build :sb_client_user, department: "あ" * 255 }
      it "有効である" do
        expect(sb_client_user_ok).to be_valid
      end
      let(:sb_client_user_ng) { build :sb_client_user, department: "あ" * 256 }
      it "無効である" do
        expect(sb_client_user_ng).to be_invalid
      end
    end
  end

  context "バリデーション(tel_validator)" do
    context "電話番号に数字以外が混ざっている場合" do
      let(:sb_client_user) { build :sb_client_user, contact_tel: "1234S678901" }
      it "無効である" do
        expect(sb_client_user).to be_invalid
      end
    end
    context "電話番号が10or11桁でない場合" do
      let(:sb_client_user_12) { build :sb_client_user, contact_tel: "123456789012" }
      it "無効である" do
        expect(sb_client_user_12).to be_invalid
      end
      let(:sb_client_user_11) { build :sb_client_user, contact_tel: "12345678901" }
      it "有効である" do
        expect(sb_client_user_11).to be_valid
      end
      let(:sb_client_user_10) { build :sb_client_user, contact_tel: "1234567890" }
      it "有効である" do
        expect(sb_client_user_10).to be_valid
      end
      let(:sb_client_user_9) { build :sb_client_user, contact_tel: "123456789" }
      it "無効である" do
        expect(sb_client_user_9).to be_invalid
      end
    end
  end
  context "バリデーション(email_validator)" do
    context "メアドに@がない場合" do
      let(:sb_client_user) { build :sb_client_user, email: "alarmbox.co.jp" }
      it "無効である" do
        expect(sb_client_user).to be_invalid
      end
    end
    context "メアドにスペースが含まれる場合" do
      let(:sb_client_user) { build :sb_client_user, email: "watanabe @alarmbox.co.jp" }
      it "無効である" do
        expect(sb_client_user).to be_invalid
      end
    end
    context "メアド（ドメイン）にスペースが含まれる場合" do
      let(:sb_client_user) { build :sb_client_user, email: "watanabe@alar mbox.co.jp" }
      it "無効である" do
        expect(sb_client_user).to be_invalid
      end
    end
    context "xx@xxの場合" do
      let(:sb_client_user) { build :sb_client_user, email: "watanabe@alarmbox" }
      it "有効である" do
        expect(sb_client_user).to be_valid
      end
    end
  end
end
