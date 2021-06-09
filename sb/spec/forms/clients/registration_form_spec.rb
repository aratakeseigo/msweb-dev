require "rails_helper"

RSpec.describe Client::RegistrationForm, type: :model do
  describe "バリデーション" do
    context "都道府県名・業種１がマスタにありSBクライアント・SBクライアントユーザーのバリデーションが有効な場合" do
      let(:client_registration_form) { create :client_registration_form }
      it "有効である" do
        expect(client_registration_form).to be_valid
      end
    end

    context "都道府県名がマスタにない場合" do
      let(:client_registration_form) { create :client_registration_form, prefecture_name: "福建省" }
      it "無効である" do
        expect(client_registration_form).to be_invalid
      end
    end

    context "業種１がマスタにない場合" do
      let(:client_registration_form) { create :client_registration_form, industry_name: "雑技団" }
      it "無効である" do
        expect(client_registration_form).to be_invalid
      end
    end

    context "SBクライアントのバリデーションが無効な場合" do
      let(:client_registration_form) { create :client_registration_form, name: "" }
      it "無効である" do
        expect(client_registration_form).to be_invalid
      end
    end

    context "ユーザーの登録が0件の場合" do
      let(:client_registration_form) { create :client_registration_form, users: {} }
      it "無効である" do
        expect(client_registration_form).to be_invalid
      end
    end

    context "SBクライアントユーザーのバリデーションが無効な場合" do
      let(:users) {
        [{
          "user_name" => "渡部　ケント",
          "user_name_kana" => "ワタベ　ケント",
          "email" => "watanabe", #メアドとして不正
          "position" => "担当部長",
          "department" => "経営企画部",
          "contact_tel" => "09044209999",
        }]
      }
      let(:client_registration_form) { create :client_registration_form, users: users }
      it "無効である" do
        expect(client_registration_form).to be_invalid
      end
    end
  end

  describe "ファイル読み込み" do
    context "異常なファイルを読み込んだ場合" do
      context "空のExcel" do
        let(:file) { file_fixture("client_registration/empty.xlsx") }
        let(:form) { Client::RegistrationForm.initFromFile(file) }
        let(:current_user) { create :internal_user }
        it "初期化できるがバリデーションエラーになる" do
          expect(form).to be_invalid
        end
      end
      context "旧Excelの拡張子の場合" do
        let(:file) { file_fixture("client_registration/ok.xls") }

        it "読み込みエラーになる" do
          expect {
            Client::RegistrationForm.initFromFile(file)
          }.to raise_error(ArgumentError)
        end
      end
      context "画像ファイルの場合" do
        let(:file) { file_fixture("client_registration/logo.jpg") }

        it "読み込みエラーになる" do
          expect {
            Client::RegistrationForm.initFromFile(file)
          }.to raise_error(ArgumentError)
        end
      end
    end

    context "内容がNGなファイルを読み込んだ場合" do
      let(:file) { file_fixture("client_registration/ng.xlsx") }
      let(:form) { Client::RegistrationForm.initFromFile(file) }
      let(:current_user) { create :internal_user }
      it "初期化できるがバリデーションエラーになる" do
        expect(form).to be_invalid
      end
    end
    context "正常なファイルを読み込んだ場合" do
      let(:file) { file_fixture("client_registration/ok.xlsx") }
      let(:form) { Client::RegistrationForm.initFromFile(file) }
      let(:current_user) { create :internal_user }
      it "初期化できる" do
        expect(form).to be_valid
      end
      context "読み込んだフォームにsave_clientを発行した場合" do
        before {
          form.current_user = current_user
        }
        subject { -> { form.save_client } }

        it "SbClientが保存される" do
          is_expected.to change { SbClient.count }.by(1)
          new_sb_client = SbClient.find(form.sb_client.id)

          expect(new_sb_client.name).to eq form.name
          expect(new_sb_client.daihyo_name).to eq form.daihyo_name
          expect(new_sb_client.zip_code).to eq form.zip_code
          expect(new_sb_client.prefecture).to eq Prefecture.find_by_name form.prefecture_name
          expect(new_sb_client.address).to eq form.address
          expect(new_sb_client.tel).to eq form.tel
          expect(new_sb_client.industry).to eq Industry.find_by_name form.industry_name
          expect(new_sb_client.industry_optional).to eq form.industry_optional
          expect(new_sb_client.established_in).to eq sprintf("%04d%02d", form.established_in.year, form.established_in.mon)
          expect(new_sb_client.capital).to eq form.capital * 1000 #円で格納
          expect(new_sb_client.annual_sales).to eq form.annual_sales * 1000 #円で格納
          expect(new_sb_client.created_user).to eq current_user
          expect(new_sb_client.updated_user).to eq current_user
        end

        it "SbClientUserが保存される" do
          is_expected.to change { SbClientUser.count }.by(form.users.size)
          new_sb_client = SbClient.find(form.sb_client.id)
          form_users = form.users
          new_sb_client.sb_client_users.each_with_index do |new_sb_client_user, i|
            expect(new_sb_client_user.name).to eq form_users[i]["user_name"]
            expect(new_sb_client_user.name_kana).to eq form_users[i]["user_name_kana"]
            expect(new_sb_client_user.contact_tel).to eq form_users[i]["contact_tel"]
            expect(new_sb_client_user.email).to eq form_users[i]["email"]
            expect(new_sb_client_user.position).to eq form_users[i]["position"]
            expect(new_sb_client_user.department).to eq form_users[i]["department"]
          end
        end
      end
    end
  end
end
