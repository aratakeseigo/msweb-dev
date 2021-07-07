require "rails_helper"

RSpec.describe ExamsController do
  let(:internal_user) { create :internal_user }
  let(:sb_guarantee_exam) { create :sb_guarantee_exam }

  subject { sb_guarantee_exam.decorate }

  describe "GET #index" do
    before do
      sign_in internal_user
      sb_guarantee_exam
    end

    context "初期画面" do

      before {get :index}

      it "デフォルトのステータスを設定してリダイレクトされること" do
        expect(response).to redirect_to exams_list_path + "?q%5Bstatus_id_eq_any%5D%5B%5D=2&q%5Bstatus_id_eq_any%5D%5B%5D=3"
      end
    end

    context "検索" do
      it "状態で検索できること" do
        get :list , params: {q: {status_id_eq_any: "2"}}
        expect(assigns(:exams).size).to eq 1
        expect(assigns(:exams).first.status_id).to eq 2
      end
      it "クライアント名で検索できること" do
        get :list , params: {q: {sb_client_name_cont: "アラーム"}}
        expect(assigns(:exams).size).to eq 1
        expect(assigns(:exams).first.sb_client.name).to eq "アラームボックス"
      end
      it "保証先名で検索できること" do
        get :list , params: {q: {sb_guarantee_customer_company_name_cont: "ボックス株式会社"}}
        expect(assigns(:exams).size).to eq 1
        expect(assigns(:exams).first.sb_guarantee_customer.company_name).to eq "アラームボックス株式会社"
      end
      it "保証先代表名で検索できること" do
        get :list , params: {q: {sb_guarantee_customer_daihyo_name_cont: "山田"}}
        expect(assigns(:exams).size).to eq 1
        expect(assigns(:exams).first.sb_guarantee_customer.daihyo_name).to eq "山田　太郎"
      end
      it "審査依頼日で検索できること" do
        get :list , params: {q: {sb_approval_applied_at_gteq: "2021/01/01"}}
      end
      it "審査担当者で検索できること" do
        get :list , params: {q: {sb_approval_applied_user_name_cont: "山田"}}
      end
      it "決裁担当者で検索できること" do
        get :list , params: {q: {sb_approval_approved_user_name_cont: "山田"}}
      end
      it "稟議承認日で検索できること" do
        get :list , params: {q: {sb_approval_approved_at_gteq: "2021/01/01"}}
      end

    end
  end
end
