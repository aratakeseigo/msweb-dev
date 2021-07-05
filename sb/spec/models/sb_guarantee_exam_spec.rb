require "rails_helper"

RSpec.describe SbGuaranteeExam, type: :model do
  context "バリデーション(長さ)" do
    context "取扱商品" do
      let(:sb_guarantee_exam_ok) { build :sb_guarantee_exam, transaction_contents: "あ" * 255 }
      it "255文字以下の場合、有効である" do
        expect(sb_guarantee_exam_ok).to be_valid
      end
      let(:sb_guarantee_exam_ng) { build :sb_guarantee_exam, transaction_contents: "あ" * 256 }
      it "256文字以上の場合、無効である" do
        expect(sb_guarantee_exam_ng).to be_invalid
      end
    end
    context "他保証会社" do
      let(:sb_guarantee_exam_ok) { build :sb_guarantee_exam, other_guarantee_companies: "あ" * 255 }
      it "255文字以下の場合、有効である" do
        expect(sb_guarantee_exam_ok).to be_valid
      end
      let(:sb_guarantee_exam_ng) { build :sb_guarantee_exam, other_guarantee_companies: "あ" * 256 }
      it "256文字以上の場合、無効である" do
        expect(sb_guarantee_exam_ng).to be_invalid
      end
    end
    context "審査検索キー" do
      let(:sb_guarantee_exam_ok) { build :sb_guarantee_exam, exam_search_key: "あ" * 255 }
      it "255文字以下の場合、有効である" do
        expect(sb_guarantee_exam_ok).to be_valid
      end
      let(:sb_guarantee_exam_ng) { build :sb_guarantee_exam, exam_search_key: "あ" * 256 }
      it "256文字以上の場合、無効である" do
        expect(sb_guarantee_exam_ng).to be_invalid
      end
    end
  end
  context "バリデーション(必須)" do
    context "受付日" do
      let(:sb_guarantee_exam_ok) { build :sb_guarantee_exam, accepted_at: Time.zone.now }
      it "空でない場合、有効である" do
        expect(sb_guarantee_exam_ok).to be_valid
      end
      let(:sb_guarantee_exam_ng) { build :sb_guarantee_exam, accepted_at: nil }
      it "空の場合、無効である" do
        expect(sb_guarantee_exam_ng).to be_invalid
      end
    end
    context "審査検索キー" do
      let(:sb_guarantee_exam_ok) { build :sb_guarantee_exam, exam_search_key: "A-10" }
      it "空でない場合、有効である" do
        expect(sb_guarantee_exam_ok).to be_valid
      end
      let(:sb_guarantee_exam_ng) { build :sb_guarantee_exam, exam_search_key: nil }
      it "空の場合、無効である" do
        expect(sb_guarantee_exam_ng).to be_invalid
      end
    end
  end
end
