module Client
  class RegistrationForm < ApplicationForm
    attribute :no, :string
    attribute :area, :string
    attribute :internal_user_id, :string
    attribute :name, :string
    attribute :daihyo_name, :string
    attribute :zip_code, :string
    attribute :address1, :string
    attribute :address2, :string
    attribute :tel, :string
    attribute :industory_code1, :string
    attribute :industory_code1, :string
    attribute :user_name, :string
    attribute :user_kana, :string
    attribute :user_email, :string
    attribute :user_position, :string
    attribute :user_department, :string
    attribute :user_tel, :string
    attribute :setsuritsu, :string
    attribute :nensho, :string
    attribute :channel, :string
    attribute :agent, :string
    attribute :hansha, :string
    attribute :ng_reason, :string
    attribute :ringi, :datetime
    attribute :kessai, :datetime
    attribute :kessai_user, :string
    attribute :contract_date, :datetime

    attr_accessor :users

    def self.initFromFile(file)
      column_mapping = {
        "Ｎｏ" => "no",
        "エリア" => "area",
        "ＳＢ担当名" => "internal_user_id",
        "クライアント名" => "name",
        "代表者名" => "daihyo_name",
        "〒" => "zip_code",
        "住所1" => "address1",
        "住所2" => "address2",
        "ＴＥＬ" => "tel",
        "業種1" => "industory_code1",
        "業種2" => "industory_code1",
        "担当者名" => "user_name",
        "担当者名カナ" => "user_kana",
        "メールアドレス" => "user_email",
        "役職" => "user_position",
        "部署" => "user_department",
        "希望連絡先" => "user_tel",
        "設立" => "setsuritsu",
        "年商（千円）" => "nensho",
        "媒体" => "channel",
        "代理店" => "agent",
        "反社チェック" => "hansha",
        "✖内容" => "ng_reason",
        "稟議日" => "ringi",
        "決裁日" => "kessai",
        "決裁担当" => "kessai_user",
        "契約日" => "contract_date",
      }
      client_hash_list = Utils::ExcelUtils.excel_to_h(file,
                                                      worksheet_index: 1,
                                                      header_row_index: 1,
                                                      list_start_row_index: 2,
                                                      start_col_index: 1,
                                                      end_col_index: 30,
                                                      header_mapping: column_mapping)

      form = Client::RegistrationForm.new(client_hash_list.first)
      client_hash_list.each do |h|
        form.add_user({
          user_name: h["user_name"],
          user_kana: h["user_kana"],
          user_email: h["user_email"],
          user_position: h["user_position"],
          user_department: h["user_department"],
          user_tel: h["user_tel"],
        })
      end
      form
    end

    def add_user(user_hash)
      @users = [] unless @users

      @users << user_hash
    end
  end
end
