require "rails_helper"

RSpec.describe Client::ExamForm, type: :model do

  WORD_OVER = "あいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそた"

  WORD_MAX = "あいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそ"

  describe "初期化" do
    let(:client) { create :sb_client, :has_agent }
    context "初期表示" do
      it "有効である" do
        
        form = Client::ExamForm.new(nil, client)
        expect(form.sb_client.name).to eq "東沖縄電力株式会社"
      end
    end

    context "更新時" do
      it "有効である" do
        params = {area_id: "1",
                  sb_tanto_id: "1",
                  name: "アラームボックス",
                  daihyo_name: "武田　太郎",
                  zip_code: "9012102",
                  prefecture_code: "14",
                  address: "川崎市高津区北見方9-9-9",
                  tel: "12345678901",
                  industry_id: "1",
                  industry_optional: "ブランド品",
                  established_in: "202106",
                  annual_sales: "33000000",
                  capital: "10000000",
                  registration_form_file: nil,other_files: nil
        }
        
        form = Client::ExamForm.new(params, client)
        form.invalid?
        expect(form.sb_client.name).to eq "アラームボックス"
      end
    end
  end

  describe "バリデーション" do
    context "代表者名にスペースがない場合" do
      let(:client_exam_form) { create :client_exam_form, daihyo_name: "鬼木達" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "代表者名が空の場合" do
      let(:client_exam_form) { create :client_exam_form, daihyo_name: "" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "代表者名が255文字以下の場合(255文字)" do
      let(:client_exam_form) { create :client_exam_form, name: "あいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしす　せ" }
      it "有効である" do
        expect(client_exam_form).to be_valid
      end
    end

    context "代表者名が255文字以上の場合(256文字)" do
      let(:client_exam_form) { create :client_exam_form, name: "あいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせそたちつてとあいうえおかきくけこさしすせ　そ" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "代表者名に半角スペースがある" do
      let(:client_exam_form) { create :client_exam_form, daihyo_name: "鬼木 達" }
      it "Formで変換され有効になる" do
        expect(client_exam_form).to be_valid
        expect(client_exam_form.sb_client.daihyo_name).to eq "鬼木　達"
      end
    end

    context "クライアント名が空の場合" do
      let(:client_exam_form) { create :client_exam_form, name: "" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "クライアント名が255文字以下の場合(255文字)" do
      let(:client_exam_form) { create :client_exam_form, name: WORD_MAX }
      it "有効である" do
        expect(client_exam_form).to be_valid
      end
    end

    context "クライアント名が255文字以上の場合(256文字)" do
      let(:client_exam_form) { create :client_exam_form, name: WORD_OVER }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "郵便番号に数字以外がある" do
      let(:client_exam_form) { create :client_exam_form, zip_code: "abcdあいう" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "郵便番号に8文字以上の場合" do
      let(:client_exam_form) { create :client_exam_form, zip_code: "12345678" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "郵便番号に8文字以下の場合" do
      let(:client_exam_form) { create :client_exam_form, zip_code: "123456" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "住所が255文字以下の場合(255文字)" do
      let(:client_exam_form) { create :client_exam_form, address: WORD_MAX }
      it "有効である" do
        expect(client_exam_form).to be_valid
      end
    end

    context "住所が255文字以上の場合(256文字)" do
      let(:client_exam_form) { create :client_exam_form, address: WORD_OVER }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "電話番号に数字以外がある" do
      let(:client_exam_form) { create :client_exam_form, tel: "abcdefgあいう" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "郵便番号に10文字または11文字以外の場合" do
      let(:client_exam_form) { create :client_exam_form, tel: "123456789" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "業種(補足)が255文字以下の場合(255文字)" do
      let(:client_exam_form) { create :client_exam_form, industry_optional: WORD_MAX }
      it "有効である" do
        expect(client_exam_form).to be_valid
      end
    end

    context "業種(補足)が255文字以上の場合(256文字)" do
      let(:client_exam_form) { create :client_exam_form, industry_optional: WORD_OVER }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "設立年月に数字以外がある" do
      let(:client_exam_form) { create :client_exam_form, established_in: "abcdあい" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "設立年月が6文字以外の場合" do
      let(:client_exam_form) { create :client_exam_form, established_in: "1234567" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "設立年月の月が1-12以外の場合" do
      let(:client_exam_form) { create :client_exam_form, established_in: "202100" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end

    context "設立年月の年が1900より大きい(1901)場合" do
      let(:client_exam_form) { create :client_exam_form, established_in: "190101" }
      it "有効である" do
        expect(client_exam_form).to be_valid
      end
    end

    context "設立年月の年が1900以下(1900)の場合" do
      let(:client_exam_form) { create :client_exam_form, established_in: "190012" }
      it "無効である" do
        expect(client_exam_form).to be_invalid
      end
    end
  end

  describe "アップロード" do
    context "申込書が存在する場合" do
      let(:client_exam_form) { create :client_exam_form, registration_form_file: fixture_file_upload("files/client_exam/registration_form_file1.pdf") }
      before { 
        client_exam_form.save_client
      }
      it "申込書が保存される" do
        sb_client = SbClient.find(client_exam_form.sb_client.id)
        expect(sb_client.registration_form_file.filename.to_s).to eq "registration_form_file1.pdf"
      end
    end

    context "ファイルが存在する場合" do
      let(:client_exam_form) { create :client_exam_form, other_files: [fixture_file_upload("files/client_exam/test1.pdf"),
                                                                      fixture_file_upload("files/client_exam/test2.pdf"),
                                                                      fixture_file_upload("files/client_exam/test3.pdf"),
                                                                      fixture_file_upload("files/client_exam/test4.pdf"),
                                                                      fixture_file_upload("files/client_exam/test5.pdf")]
      }
      before { 
        client_exam_form.save_client
      }
      it "ファイルが保存される" do
        sb_client = SbClient.find(client_exam_form.sb_client.id)
        expect(sb_client.other_files.size).to eq 5
      end
    end
  end

  describe "ファイルアップロード制限" do
    context "ファイルが5個以下(5個)存在する場合" do
      let(:client_exam_form) { create :client_exam_form, other_files: [fixture_file_upload("files/client_exam/test1.pdf"),
                                                                      fixture_file_upload("files/client_exam/test2.pdf"),
                                                                      fixture_file_upload("files/client_exam/test3.pdf"),
                                                                      fixture_file_upload("files/client_exam/test4.pdf"),
                                                                      fixture_file_upload("files/client_exam/test5.pdf")]
      }
      before { 
        client_exam_form.other_files_invalid?
      }
      it "エラーにならない" do
        expect(client_exam_form.errors[:other_files]).to eq []
      end
    end

    context "ファイルが6個以上(6個)存在する場合" do
      let(:client_exam_form) { create :client_exam_form, other_files: [fixture_file_upload("files/client_exam/test1.pdf"),
                                                                      fixture_file_upload("files/client_exam/test2.pdf"),
                                                                      fixture_file_upload("files/client_exam/test3.pdf"),
                                                                      fixture_file_upload("files/client_exam/test4.pdf"),
                                                                      fixture_file_upload("files/client_exam/test5.pdf"),
                                                                      fixture_file_upload("files/client_exam/test6.pdf")]
      }
      before { 
        client_exam_form.other_files_invalid?
      }
      it "エラーになる" do
        expect(client_exam_form.errors[:other_files]).to eq ["は5件までしか保存できません"]
      end
    end
  end
end