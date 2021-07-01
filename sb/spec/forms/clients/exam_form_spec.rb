require "rails_helper"

RSpec.describe Client::ExamForm, type: :model do
  let(:client) { create :sb_client, :client_exam_form }
  let(:client_has_file) { create :sb_client, :has_file }
  let(:user) { create :internal_user }
  let(:client_has_exam) { create :sb_client, :has_exam }
  let(:client_has_exam_available_flag_false) { create :sb_client, :has_exam_available_flag_false }
  let(:client_has_no_entity) { create :sb_client, :has_no_entity }

  describe "初期化" do
    context "初期表示" do
      let(:form) { Client::ExamForm.new(nil, client) }
      it "一覧画面で選択されたデータのsb_clientが表示される" do
        expect(form.area_id).to eq client.area_id
        expect(form.sb_tanto_id).to eq client.sb_tanto_id
        expect(form.name).to eq client.name
        expect(form.daihyo_name).to eq client.daihyo_name
        expect(form.zip_code).to eq client.zip_code
        expect(form.prefecture_code).to eq client.prefecture_code
        expect(form.address).to eq client.address
        expect(form.tel).to eq client.tel
        expect(form.industry_id).to eq client.industry_id
        expect(form.industry_optional).to eq client.industry_optional
        expect(form.established_in).to eq client.established_in
        expect(form.annual_sales).to eq client.annual_sales
        expect(form.capital).to eq client.capital
      end
    end

    context "初期表示時にsb_client_examが存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client) }
      it "sb_client_examの項目がnilである" do
        expect(form.reject_reason).to eq nil
        expect(form.anti_social).to eq nil
        expect(form.anti_social_memo).to eq nil
        expect(form.tsr_score).to eq nil
        expect(form.tdb_score).to eq nil
        expect(form.communicate_memo).to eq nil
      end
    end

    context "初期表示時に有効フラグがtrueのsb_client_examが存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam_available_flag_false) }
      it "sb_client_examの項目がnilである" do
        expect(form.reject_reason).to eq nil
        expect(form.anti_social).to eq nil
        expect(form.anti_social_memo).to eq nil
        expect(form.tsr_score).to eq nil
        expect(form.tdb_score).to eq nil
        expect(form.communicate_memo).to eq nil
      end
    end

    context "初期表示時に有効フラグがtrueのsb_client_examが存在する場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "sb_client_examの項目がnilである" do
        expect(form.reject_reason).to eq "否決理理由"
        expect(form.anti_social).to eq true
        expect(form.anti_social_memo).to eq "反社メモ"
        expect(form.tsr_score).to eq "55"
        expect(form.tdb_score).to eq "66"
        expect(form.communicate_memo).to eq "社内連絡メモ"
      end
    end
  end

  describe "can_applyの設定" do
    context "sb_approvalのstatusが0（申請中）の場合" do
      let!(:client_has_approval_apply) { create :sb_client, :has_approval_apply }
      let(:form) { Client::ExamForm.new(nil, client_has_approval_apply) }
      it "can_applyがfalseに設定される" do
        expect(form.can_apply).to eq false
      end
    end

    context "sb_approvalのstatusが1（承認）の場合" do
      let!(:client_has_approval_approved) { create :sb_client, :has_approval_approved }
      let(:form) { Client::ExamForm.new(nil, client_has_approval_approved) }
      it "can_applyがfalseに設定される" do
        expect(form.can_apply).to eq false
      end
    end

    context "sb_approvalのstatusが8（取り下げ）の場合" do
      let!(:client_has_approval_withdrawed) { create :sb_client, :has_approval_withdrawed }
      let(:form) { Client::ExamForm.new(nil, client_has_approval_withdrawed) }
      it "can_applyがtrueに設定される" do
        expect(form.can_apply).to eq true
      end
    end

    context "sb_approvalのstatusが9（差し戻し）の場合" do
      let!(:client_has_approval_remand) { create :sb_client, :has_approval_remand }
      let(:form) { Client::ExamForm.new(nil, client_has_approval_remand) }
      it "can_applyがtrueに設定される" do
        expect(form.can_apply).to eq true
      end
    end

    context "sb_approvalが存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "can_applyがtrueに設定される" do
        expect(form.can_apply).to eq true
      end
    end

    context "sb_client_examが存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client) }
      it "can_applyがnilに設定される" do
        expect(form.can_apply).to eq nil
      end
    end
  end

  describe "各情報有無設定" do
    context "ab情報が存在する場合" do
      let!(:customer) { create :customer_master, house_company_code: client_has_exam.entity.house_company_code }
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "ab情報がありである" do
        expect(form.ab_info).to eq "あり"
      end
    end

    context "ab情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "ab情報がなしである" do
        expect(form.ab_info).to eq "なし"
      end
    end

    context "bl情報が存在する場合" do
      let!(:bl_info) { create :accs_bl_info, corporate_code: client_has_exam.entity.house_company_code }
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "bl情報がありである" do
        expect(form.bl_info).to eq "あり"
      end
    end

    context "bl情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "bl情報がなしである" do
        expect(form.bl_info).to eq "なし"
      end
    end

    context "by情報が存在する場合" do
      let!(:by_info) { create :by_customer, entity_id: client_has_exam.entity.id }
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "by情報がありである" do
        expect(form.by_info).to eq "あり"
      end
    end

    context "by情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "by情報がなしである" do
        expect(form.by_info).to eq "なし"
      end
    end

    context "審査結果情報が存在する場合" do
      let!(:guarantee_client) { create :sb_guarantee_client }
      let!(:guarantee_customer) { create :sb_guarantee_customer, entity_id: client_has_exam.entity.id }
      let!(:guarantee_exam) { create :sb_guarantee_exam, sb_guarantee_client_id: guarantee_client.id, sb_guarantee_customer_id: guarantee_customer.id }
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "審査結果情報がありである" do
        expect(form.exam_info).to eq "あり"
      end
    end

    context "審査結果情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_exam) }
      it "審査結果情報がなしである" do
        expect(form.bl_info).to eq "なし"
      end
    end

    context "entity情報が存在しない場合" do
      let(:form) { Client::ExamForm.new(nil, client_has_no_entity) }
      it "各情報が設定されない" do
        expect(form.exam_info).to eq nil
        expect(form.ab_info).to eq nil
        expect(form.bl_info).to eq nil
      end
    end
  end

  describe "データ更新" do
    context "バリデーションエラーがない更新時" do
      let(:params) {
        { area_id: "2",
          sb_tanto_id: "2",
          name: "西東京株式会社",
          daihyo_name: "武田　太郎",
          zip_code: "9012102",
          prefecture_code: "14",
          address: "川崎市高津区北見方9-9-9",
          tel: "12345678901",
          industry_id: "2",
          industry_optional: "ブランド品",
          established_in: "202106",
          annual_sales: "33000000",
          capital: "10000000",
          tsr_score: "77" ,
          tdb_score: "88",
          anti_social: "false",
          anti_social_memo: "反社メモ変更",
          reject_reason: "否決理理由変更",
          communicate_memo: "社内連絡メモ変更",
          registration_form_file: nil,
          other_files: nil }
      }
      let(:form) { Client::ExamForm.new(params, client_has_exam) }
      before {
        form.current_user = user
        form.to_sb_client
        form.other_files_invalid?
        form.invalid?
        form.save_client
      }
      it "対象データが更新される" do
        # 更新されているか確認の為client.idでsb_clientを検索
        new_sb_client = SbClient.find(client_has_exam.id)
        expect(form.invalid?).to eq false
        expect(form.area_id).to eq "2"
        expect(new_sb_client.area_id).to eq 2
        expect(form.sb_tanto_id).to eq "2"
        expect(new_sb_client.sb_tanto_id).to eq 2
        expect(form.name).to eq "西東京株式会社"
        expect(new_sb_client.name).to eq "西東京株式会社"
        expect(form.daihyo_name).to eq "武田　太郎"
        expect(new_sb_client.daihyo_name).to eq "武田　太郎"
        expect(form.zip_code).to eq "9012102"
        expect(new_sb_client.zip_code).to eq "9012102"
        expect(form.prefecture_code).to eq "14"
        expect(new_sb_client.prefecture_code).to eq 14
        expect(form.address).to eq "川崎市高津区北見方9-9-9"
        expect(new_sb_client.address).to eq "川崎市高津区北見方9-9-9"
        expect(form.tel).to eq "12345678901"
        expect(new_sb_client.tel).to eq "12345678901"
        expect(form.industry_id).to eq "2"
        expect(new_sb_client.industry_id).to eq 2
        expect(form.industry_optional).to eq "ブランド品"
        expect(new_sb_client.industry_optional).to eq "ブランド品"
        expect(form.established_in).to eq "202106"
        expect(new_sb_client.established_in).to eq "202106"
        expect(form.annual_sales).to eq "33000000"
        expect(new_sb_client.annual_sales).to eq 33000000
        expect(form.capital).to eq "10000000"
        expect(new_sb_client.capital).to eq 10000000
        expect(form.current_user).to eq user
        expect(new_sb_client.updated_user).to eq user
        # sb_client_exam
        expect(form.tsr_score).to eq "77"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).tsr_score).to eq "77"
        expect(form.tdb_score).to eq "88"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).tdb_score).to eq "88"
        expect(form.anti_social).to eq "false"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).anti_social).to eq false
        expect(form.anti_social_memo).to eq "反社メモ変更"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).anti_social_memo).to eq "反社メモ変更"
        expect(form.reject_reason).to eq "否決理理由変更"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).reject_reason).to eq "否決理理由変更"
        expect(form.communicate_memo).to eq "社内連絡メモ変更"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).communicate_memo).to eq "社内連絡メモ変更"
      end

      it "status_idの変更がされていない" do
        new_sb_client = SbClient.find(client.id)
        expect(form.status_id).to eq 1
        expect(new_sb_client.status_id).to eq 1
      end
    end

    context "稟議申請ボタン押下時" do
      let(:params) {{area_id: "2",
                      sb_tanto_id: "2",
                      name: "西東京株式会社",
                      daihyo_name: "武田　太郎",
                      zip_code: "9012102",
                      prefecture_code: "14",
                      address: "川崎市高津区北見方9-9-9",
                      tel: "12345678901",
                      industry_id: "2",
                      industry_optional: "ブランド品",
                      established_in: "202106",
                      annual_sales: "33000000",
                      capital: "10000000",
                      tsr_score: "77" ,
                      tdb_score: "88",
                      anti_social: "false",
                      anti_social_memo: "反社メモ変更",
                      reject_reason: "否決理理由変更",
                      communicate_memo: "社内連絡メモ変更",            
                      registration_form_file: nil,
                      other_files: nil
      }}
      let(:form) {Client::ExamForm.new(params, client_has_exam)}
      before {
        form.current_user = user
        form.to_sb_client
        form.other_files_invalid?
        form.invalid?
        form.sb_client_exam_apply
        form.save_client
      }

      it "対象データが更新される" do
        # 更新されているか確認の為client.idでsb_clientを検索
        new_sb_client = SbClient.find(client_has_exam.id)
        expect(form.invalid?).to eq false
        expect(form.area_id).to eq "2"
        expect(new_sb_client.area_id).to eq 2
        expect(form.sb_tanto_id).to eq "2"
        expect(new_sb_client.sb_tanto_id).to eq 2
        expect(form.name).to eq "西東京株式会社"
        expect(new_sb_client.name).to eq "西東京株式会社"
        expect(form.daihyo_name).to eq "武田　太郎"
        expect(new_sb_client.daihyo_name).to eq "武田　太郎"
        expect(form.zip_code).to eq "9012102"
        expect(new_sb_client.zip_code).to eq "9012102"
        expect(form.prefecture_code).to eq "14"
        expect(new_sb_client.prefecture_code).to eq 14
        expect(form.address).to eq "川崎市高津区北見方9-9-9"
        expect(new_sb_client.address).to eq "川崎市高津区北見方9-9-9"
        expect(form.tel).to eq "12345678901"
        expect(new_sb_client.tel).to eq "12345678901"
        expect(form.industry_id).to eq "2"
        expect(new_sb_client.industry_id).to eq 2
        expect(form.industry_optional).to eq "ブランド品"
        expect(new_sb_client.industry_optional).to eq "ブランド品"
        expect(form.established_in).to eq "202106"
        expect(new_sb_client.established_in).to eq "202106"
        expect(form.annual_sales).to eq "33000000"
        expect(new_sb_client.annual_sales).to eq 33000000
        expect(form.capital).to eq "10000000"
        expect(new_sb_client.capital).to eq 10000000
        expect(form.current_user).to eq user
        expect(new_sb_client.updated_user).to eq user
        # sb_client_exam
        expect(form.tsr_score).to eq "77"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).tsr_score).to eq "77"
        expect(form.tdb_score).to eq "88"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).tdb_score).to eq "88"
        expect(form.anti_social).to eq "false"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).anti_social).to eq false
        expect(form.anti_social_memo).to eq "反社メモ変更"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).anti_social_memo).to eq "反社メモ変更"
        expect(form.reject_reason).to eq "否決理理由変更"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).reject_reason).to eq "否決理理由変更"
        expect(form.communicate_memo).to eq "社内連絡メモ変更"
        expect(new_sb_client.sb_client_exams.find_by(available_flag: true).communicate_memo).to eq "社内連絡メモ変更"

      end
      
      it "status_idが3(決裁待ち)に更新される" do
        new_sb_client = SbClient.find(client_has_exam.id)
        expect(new_sb_client.status_id).to eq 3
      end
    end
  end

  describe "バリデーション" do
    context "sb_clientのバリデーションチェックに違反してる場合" do
      let(:params) { { zip_code: "901210" } }
      let(:form) { Client::ExamForm.new(params, client) }
      before {
        form.current_user = user
        form.to_sb_client
        form.invalid?
      }
      it "バリデーションエラーになる" do
        expect(form).to be_invalid
      end
    end
  end

  describe "アップロード" do
    context "申込書が保存されておらず、申込書がアップロードされた場合" do
      let(:params) { { registration_form_file: fixture_file_upload("files/client_exam/registration_form_file1.pdf") } }
      let(:form) { Client::ExamForm.new(params, client) }
      before {
        form.save_client
      }
      it "申込書が保存される" do
        sb_client = SbClient.find(client.id)
        expect(sb_client.registration_form_file.filename.to_s).to eq "registration_form_file1.pdf"
      end
    end

    context "申込書が保存されており、申込書がアップロードされた場合" do
      let(:params) { { registration_form_file: fixture_file_upload("files/client_exam/registration_form_file2.pdf") } }
      let(:form) { Client::ExamForm.new(params, client_has_file) }
      before {
        form.save_client
      }
      it "アップロードされた申込書に更新される" do
        sb_client = SbClient.find(client_has_file.id)
        expect(sb_client.registration_form_file.filename.to_s).to eq "registration_form_file2.pdf"
      end
    end

    context "ファイル保存されておらず、5個以下がアップロードされた場合" do
      let(:params) {
        { other_files: [fixture_file_upload("files/client_exam/test1.pdf"),
                       fixture_file_upload("files/client_exam/test2.pdf"),
                       fixture_file_upload("files/client_exam/test3.pdf"),
                       fixture_file_upload("files/client_exam/test4.pdf"),
                       fixture_file_upload("files/client_exam/test5.pdf")] }
      }
      let(:form) { Client::ExamForm.new(params, client) }

      context "ファイル件数のバリデーションをチェックした場合" do
        it "エラーにならない" do
          expect(form.other_files_invalid?).to eq false
          expect(form.errors[:other_files]).to eq []
        end
      end

      context "sb_clientが保存された場合" do
        before {
          form.save_client
        }
        it "ファイルが保存される" do
          sb_client = SbClient.find(client.id)
          expect(sb_client.other_files.size).to eq 5
        end
      end
    end

    context "ファイル保存されており、保存されているファイルとアップロードされたファイルの合計が5個以下の場合" do
      let(:params) {
        { other_files: [fixture_file_upload("files/client_exam/test1.pdf"),
                       fixture_file_upload("files/client_exam/test2.pdf"),
                       fixture_file_upload("files/client_exam/test3.pdf"),
                       fixture_file_upload("files/client_exam/test4.pdf")] }
      }
      let(:form) { Client::ExamForm.new(params, client_has_file) }

      context "ファイル件数のバリデーションをチェックした場合" do
        it "エラーにならない" do
          expect(form.other_files_invalid?).to eq false
          expect(form.errors[:other_files]).to eq []
        end
      end

      context "sb_clientが保存された場合" do
        before {
          form.save_client
        }
        it "ファイルが保存される" do
          sb_client = SbClient.find(client_has_file.id)
          expect(sb_client.other_files.size).to eq 5
        end
      end
    end

    context "ファイル保存されておらず、6個以上アップロードされた場合" do
      let(:params) {
        { other_files: [fixture_file_upload("files/client_exam/test1.pdf"),
                       fixture_file_upload("files/client_exam/test2.pdf"),
                       fixture_file_upload("files/client_exam/test3.pdf"),
                       fixture_file_upload("files/client_exam/test4.pdf"),
                       fixture_file_upload("files/client_exam/test5.pdf"),
                       fixture_file_upload("files/client_exam/test6.pdf")] }
      }
      let(:form) { Client::ExamForm.new(params, client) }
      it "ファイル件数のバリデーションでエラーになる" do
        expect(form.other_files_invalid?).to eq true
        expect(form.errors[:other_files]).to eq ["は5件までしか保存できません"]
      end
    end

    context "ファイル保存されており、保存されているファイルとアップロードされたファイルの合計が6個以上の場合" do
      let(:params) {
        { other_files: [fixture_file_upload("files/client_exam/test1.pdf"),
                       fixture_file_upload("files/client_exam/test2.pdf"),
                       fixture_file_upload("files/client_exam/test3.pdf"),
                       fixture_file_upload("files/client_exam/test4.pdf"),
                       fixture_file_upload("files/client_exam/test5.pdf")] }
      }
      let(:form) { Client::ExamForm.new(params, client_has_file) }
      it "ファイル件数のバリデーションでエラーになる" do
        expect(form.other_files_invalid?).to eq true
        expect(form.errors[:other_files]).to eq ["は5件までしか保存できません"]
      end
    end
  end
end
