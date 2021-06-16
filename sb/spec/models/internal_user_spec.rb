require "rails_helper"

RSpec.describe InternalUser, type: :model do
  context "SBを利用可能なユーザか" do
    context "sb_user_permissionが存在しない場合" do
      let!(:internal_user) { create :internal_user_no_sb }
      it "false" do
        expect(internal_user.is_sb_user?).to eq false
      end
    end
    context "sb_user_permissionが存在する場合" do
      let!(:internal_user) { create :internal_user }
      it "true" do
        expect(internal_user.is_sb_user?).to eq true
      end
    end
  end
  context "決裁可能金額を取得する" do
    context "sb_user_permissionが存在しない場合" do
      let!(:internal_user) { create :internal_user_no_sb }
      it "0が返る" do
        expect(internal_user.approvable_amount).to eq 0
      end
    end
    context "sb_user_permissionが存在する場合" do
      let!(:internal_user) { create :internal_user }
      it "0より大きい値が返る" do
        expect(internal_user.approvable_amount).to be > 0
        expect(internal_user.approvable_amount).to eq SbUserPosition::STAFF.approvable_amount
      end
    end
  end
  context "ポジションを比較する" do
    context "sb_user_permissionが存在しない場合" do
      let!(:internal_user) { create :internal_user_no_sb }
      it "falseが返る" do
        expect(internal_user.is_position_upper_than_or_equal?(SbUserPosition::LEADER)).to eq false
      end
    end
    context "自身がマネージャで" do
      context "リーダー以上か聞いた場合" do
        let!(:internal_user) { create :internal_user, :manager }
        it "trueが返る" do
          expect(internal_user.is_position_upper_than_or_equal?(SbUserPosition::LEADER)).to eq false
        end
      end
      context "マネージャ以上か聞いた場合" do
        let!(:internal_user) { create :internal_user, :manager }
        it "trueが返る" do
          expect(internal_user.is_position_upper_than_or_equal?(SbUserPosition::MANAGER)).to eq false
        end
      end
      context "副部長以上か聞いた場合" do
        let!(:internal_user) { create :internal_user, :manager }
        it "falseが返る" do
          expect(internal_user.is_position_upper_than_or_equal?(SbUserPosition::SUBDIRECTOR)).to eq false
        end
      end
    end
  end
end
