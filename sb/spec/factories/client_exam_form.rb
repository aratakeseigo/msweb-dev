FactoryBot.define do
  factory :client_exam_form, class: "Client::ExamForm" do
    transient do
      sb_client { build :sb_client, :has_agent }
    end

    params {{
            area_id: "1" ,
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
            registration_form_file: nil,
            other_files: nil
            }}

    initialize_with  { new(params, sb_client) }

    trait :save_client do
      self.save_client
    end
  end
end
