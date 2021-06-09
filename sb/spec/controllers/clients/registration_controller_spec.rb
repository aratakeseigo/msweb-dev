require "rails_helper"

RSpec.describe Clients::RegistrationController, type: :controller do
  let(:current_user) { create(:internal_user) }
  before do
    sign_in current_user
  end
  describe "POST #upload" do
    context "バリデーションOKのファイルをアップロードした場合" do
      before { post :upload, params: { input_file: fixture_file_upload("files/client_registration/ok.xlsx") } }
      it "確認画面が表示される" do
        expect(response).to render_template :upload
      end
    end
    context "バリデーションNGのファイルをアップロードした場合" do
      before { post :upload, params: { input_file: fixture_file_upload("files/client_registration/ng.xlsx") } }
      it "アップロード画面が表示される" do
        expect(response).to render_template :index
      end
    end
    context "xlsx以外のファイルをアップロードした場合" do
      before { post :upload, params: { input_file: fixture_file_upload("files/client_registration/ok.xls") } }
      it "アップロード画面が表示される" do
        expect(response).to render_template :index
      end
    end
  end
  describe "POST #create" do
    context "確認画面でそのまま送信した場合" do
      let(:form) {
        file = file_fixture("client_registration/ok.xlsx")
        form = Client::RegistrationForm.initFromFile(file)
        form
      }
      it "クライアント一覧画面にリダイレクトされる" do
        post :create, params: {
                        registration_form: form.to_json,
                        registration_form_users: form.users.to_json,
                      }
        expect(response).to redirect_to clients_list_path
      end
      it "SbClientが保存される" do
        expect {
          post :create, params: {
                          registration_form: form.to_json,
                          registration_form_users: form.users.to_json,
                        }
        }.to change { SbClient.count }.by(1)
      end
    end

    context "確認画面のデータがバリデーションエラーで送信した場合（異常ケース）" do
      let(:form) {
        file = file_fixture("client_registration/ng.xlsx")
        form = Client::RegistrationForm.initFromFile(file)
        form
      }
      it "アップロード画面が表示される" do
        post :create, params: {
                        registration_form: form.to_json,
                        registration_form_users: form.users.to_json,
                      }
        expect(response).to render_template :index
      end
      it "SbClientが保存されない" do
        expect {
          post :create, params: {
                          registration_form: form.to_json,
                          registration_form_users: form.users.to_json,
                        }
        }.to change { SbClient.count }.by(0)
      end
    end
  end
end
