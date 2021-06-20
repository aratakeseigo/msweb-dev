require "rails_helper"

RSpec.describe Clients::ExamController, type: :controller do
  let(:current_user) { create(:internal_user, :manager) }
  let(:client1) { create :sb_client, :has_no_agent }
  let(:client2) { create :sb_client, :has_agent }
  before do
    sign_in current_user
    client1
    client2
  end

  describe "GET #edit" do
    context "存在するsb_clientsのidがパラメータで渡された場合" do
      before { get :edit, params: { id: client1.id } }
      it "編集画面が表示される" do
        expect(response).to render_template :edit
        expect(assigns(:form).sb_client.id).to eq client1.id
      end
    end
  end

  describe "POST #update" do
    context "バリデーションOKの項目でをアップデートした場合" do
      before { post :update, params: { 
                                  id: client1.id, area_id: "2", sb_tanto_id: "2", name: "西東京建設", daihyo_name: "山田　一郎", zip_code: "9012102", prefecture_code: "33",
                                  address: "川崎市高津区北見方9-9-9",tel: "12345678901", industry_id: "1", industry_optional: "ブランド品", established_in: "202106", annual_sales: "33000000",
                                  capital: "10000000", registration_form_file: fixture_file_upload("files/client_exam/registration_form_file1.pdf"),
                                  other_files: [fixture_file_upload("files/client_exam/test1.pdf"), fixture_file_upload("files/client_exam/test2.pdf"), fixture_file_upload("files/client_exam/test3.pdf"),
                                  fixture_file_upload("files/client_exam/test4.pdf"), fixture_file_upload("files/client_exam/test5.pdf")] } }
      it "クライアント一覧画面へ遷移する" do
        updated_sb_client = SbClient.find(client1.id)
        expect(response).to redirect_to clients_list_path
        expect(updated_sb_client.name).to eq "西東京建設"
        expect(updated_sb_client.registration_form_file.filename.to_s).to eq "registration_form_file1.pdf"
        expect(updated_sb_client.other_files.size).to eq 5
      end
    end

    context "ファイルが6件以上の場合" do
      before { post :update, params: { 
                                  id: client1.id, other_files: [fixture_file_upload("files/client_exam/test1.pdf"), fixture_file_upload("files/client_exam/test2.pdf"), fixture_file_upload("files/client_exam/test3.pdf"),fixture_file_upload("files/client_exam/test4.pdf"), fixture_file_upload("files/client_exam/test5.pdf"), fixture_file_upload("files/client_exam/test6.pdf")] } }
      it "クライアント一覧画面へ遷移する" do
        updated_sb_client = SbClient.find(client1.id)
        expect(response).to redirect_to clients_list_path
        expect(updated_sb_client.name).to eq "西東京建設"
        expect(updated_sb_client.registration_form_file.filename.to_s).to eq "registration_form_file1.pdf"
        expect(updated_sb_client.other_files.size).to eq 5
      end
    end

  end

end