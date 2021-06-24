require "rails_helper"

RSpec.describe Clients::RegistrationExamsController, type: :controller do
  let(:current_user) { create(:internal_user, :manager) }
  let(:sb_client) { create :sb_client }
  before do
    sign_in current_user
  end
  describe "POST #upload" do
    context "バリデーションOKのファイルをアップロードした場合" do
      before {
        post :upload, params: {
                        id: sb_client.id,
                        input_file: fixture_file_upload("files/exam_registration/ok_no_client.xlsx"),
                      }
      }
      it "確認画面が表示される" do
        expect(response).to render_template :upload
      end
    end
    context "バリデーションNGのファイルをアップロードした場合" do
      before {
        post :upload, params: {
                        id: sb_client.id,
                        input_file: fixture_file_upload("files/exam_registration/ng.xlsx"),
                      }
      }
      it "アップロード画面が表示される" do
        expect(response).to render_template :index
      end
    end
    context "xlsx以外のファイルをアップロードした場合" do
      before {
        post :upload, params: {
                        id: sb_client.id,
                        input_file: fixture_file_upload("files/exam_registration/ok.xls"),
                      }
      }
      it "アップロード画面が表示される" do
        expect(response).to render_template :index
      end
    end
  end
  describe "POST #create" do
    context "確認画面でそのまま送信した場合" do
      let(:form) {
        file = fixture_file_upload("files/exam_registration/ok_no_client.xlsx")
        form = Exam::RegistrationForm.initFromFile(sb_client, current_user, file)
        form
      }
      let(:params) {
        {
          id: sb_client.id,
          guarantee_exam_request_id: form.sb_guarantee_exam_request.id,
        }
      }

      it "クライアント一覧画面にリダイレクトされる" do
        post :create, params: params
        expect(response).to redirect_to exams_path
      end
      it "SbGuaranteeExamが保存される" do
        expect {
          post :create, params: params
        }.to change { SbGuaranteeExam.count }.by(3)
      end
    end

    context "確認画面が表示できているがcreateでバリデーションエラーになった場合（異常ケース）" do
      let(:form) {
        file = fixture_file_upload("files/exam_registration/ng.xlsx")
        form = Exam::RegistrationForm.initFromFile(sb_client, current_user, file)
        form
      }
      let(:params) {
        {
          id: sb_client.id,
          guarantee_exam_request_id: form.sb_guarantee_exam_request.id,
        }
      }
      it "アップロード画面が表示される" do
        post :create, params: params
        expect(response).to render_template :index
      end
      it "SbGuaranteeExamが保存されない" do
        expect {
          post :create, params: params
        }.to change { SbGuaranteeExam.count }.by(0)
      end
    end

    context "createでファイルが見つからない場合（異常ケース）" do
      let(:form) {
        file = fixture_file_upload("files/exam_registration/ng.xlsx")
        form = Exam::RegistrationForm.initFromFile(sb_client, current_user, file)
        form
      }
      let(:params) {
        {
          id: sb_client.id,
          guarantee_exam_request_id: -100,
        }
      }
      it "アップロード画面が表示される" do
        post :create, params: params
        expect(response).to render_template :index
      end
      it "SbGuaranteeExamが保存されない" do
        expect {
          post :create, params: params
        }.to change { SbGuaranteeExam.count }.by(0)
      end
    end

    context "createで審査依頼IDでがあるが、別クライアントIDに紐付いている場合（異常ケース）" do
      let(:sb_client2) { create :sb_client }
      let(:sb_guarantee_exam_request_2) { create :sb_guarantee_exam_request, sb_client: sb_client2 }
      let(:form) {
        file = fixture_file_upload("files/exam_registration/ng.xlsx")
        form = Exam::RegistrationForm.initFromFile(sb_client, current_user, file)
        form
      }
      let(:params) {
        {
          id: sb_client2.id,
          guarantee_exam_request_id: form.sb_guarantee_exam_request.id,
        }
      }
      it "アップロード画面が表示される" do
        post :create, params: params
        expect(response).to render_template :index
      end
      it "SbGuaranteeExamが保存されない" do
        expect {
          post :create, params: params
        }.to change { SbGuaranteeExam.count }.by(0)
      end
    end
  end
end
