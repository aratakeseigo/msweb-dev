require "rails_helper"

RSpec.describe ClientsController do
  let(:internal_user) { create :internal_user }
  let(:client1) { create :sb_client, :has_no_agent }
  let(:client2) { create :sb_client, :has_agent }
  let(:escape_client) { create :sb_client, :escape_sequence }
  # データをdecorate
  subject { client1.decorate }

  describe "GET #list" do
    before do
      sign_in internal_user
      client1
      client2
      escape_client
    end

    context "初期画面" do

      before {get :list}

      it "作成されたデータdecorateされてclientにわたされること" do
        expect(assigns(:clients).first).to eq subject
      end

      it "created_atがdecorateされていること" do
        expect(assigns(:clients).first.created_at).to eq "2021/06/01"
      end

      it "sb_agent.nameがdecorateされていること" do
        expect(assigns(:clients).first.sb_agent_name).to eq "なし"
      end
    end

    context "検索" do
      it "状態で検索できること" do
        get :list, params: {q: {status_id_eq: "1"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.status_id).to eq 1
      end

      it "エリアで検索できること" do
        get :list, params: {q: {area_id_eq: "1"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.area_id).to eq 1
      end

      it "SB担当者名で検索できること" do
        get :list, params: {q: {sb_tanto_name_cont: "担当者１"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.sb_tanto.name).to eq "SB担当者１太郎"
      end

      it "クライアント名で検索できること" do
        get :list, params: {q: {name_cont: "ラームボック"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.name).to eq  "アラームボックス" 
      end

      it "代表者名で検索できること" do
        get :list, params: {q: {daihyo_name_cont: "浩"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.daihyo_name).to eq  "武田　浩和" 
      end

      it "都道府県で検索できること" do
        get :list, params: {q: {prefecture_code_eq: "13"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.prefecture_code).to eq 13
      end

      it "電話番号で検索できること" do
        get :list, params: {q: {tel_eq: "00000000000"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.tel).to eq "00000000000" 
      end

      it "担当者名で検索できること" do
        get :list, params: {q: {sb_client_users_name_cont: "太"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.sb_client_users.first.name).to eq "山田　太郎"
      end

      it "希望連絡先で検索できること" do
        get :list, params: {q: {sb_client_users_contact_tel_eq: "11111111111"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.sb_client_users.first.contact_tel).to eq "11111111111"
      end

      it "媒体で検索できること" do
        get :list, params: {q: {channel_id_eq: "1"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.channel_id).to eq 1
      end

      it "代理店で検索できること" do
        get :list, params: {q: {sb_agent_name_cont: "スト代理"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.sb_agent.name).to eq "テスト代理店"
      end

      it "登録日(from)で検索できること" do
        get :list, params: {q: {created_at_gteq: "2021-06-02"}}
        expect(assigns(:clients).size).to eq 2
        expect(assigns(:clients).first.created_at).to eq "2021/06/02"
      end

      it "登録日(to)で検索できること" do
        get :list, params: {q: {created_at_lteq_end_of_day: "2021-06-01"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.created_at).to eq "2021/06/01"
      end

      it "登録日(from)、登録日(to)で検索できること" do
        get :list, params: {q: {created_at_gteq: "2021-06-02", created_at_lteq_end_of_day: "2021-06-03"}}
        expect(assigns(:clients).size).to eq 2
      end

      it "全項目に入力し検索できること" do
        get :list, params: {q: {status_id_eq: "2", area_id_eq: "2", sb_tanto_name_cont: "担当者２", name_cont: "沖縄", daihyo_name_cont: "風平",prefecture_code_eq: "47",tel_eq: "11111111111", sb_client_users_name_cont: "浜", sb_client_users_contact_tel_eq: "44444444444", channel_id_eq: "2", sb_agent_name_cont: "スト代理",created_at_gteq: "2021-06-02", created_at_lteq_end_of_day: "2021-06-02"}}
        expect(assigns(:clients).size).to eq 1
        expect(assigns(:clients).first.name).to eq "東沖縄電力株式会社"
      end

      it "クライアント名と代表者名がそれぞれ別のレコードに登録されている値を設定した場合、検索できないこと" do
        # get :list, params: {q: {name: "アラームボックス", daihyo_name_cont: "東風平　太郎"}}
        get :list, params: {q: {status_id_eq: "", area_id_eq: "", sb_tanto_name_cont: "", name_cont: "アラームボックス", daihyo_name_cont: "東風平　太郎",prefecture_code_eq: "",tel_eq: "", sb_client_users_name_cont: "", sb_client_users_contact_tel_eq: "", channel_id_eq: "", sb_agent_name_cont: "",created_at_gteq: "", created_at_lteq_end_of_day: ""}}
        expect(assigns(:clients).size).to eq 0
      end

      it "特殊文字で検索できること" do
        get :list, params: {q: {name_cont: "'%"}}
        expect(assigns(:clients).first.name).to eq "アラーム'%ボックス"
      end
    end
  end
end
