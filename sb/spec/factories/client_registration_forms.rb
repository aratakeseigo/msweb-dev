FactoryBot.define do
  factory :client_registration_form, class: "Client::RegistrationForm" do
    company_name { "アラームボックス" }
    daihyo_name { "武田　太郎" }
    zip_code { "2130005" }
    prefecture_name { "神奈川県" }
    address { "川崎市高津区北見方9-9-9" }
    tel { "0120111222" }
    industry_name { "繊維・衣服卸売業" }
    industry_optional { "オリジナルブランdo" }
    established_in { "2001/12/01" }
    capital { "1000000" }
    annual_sales { "2000000" }
    users {
      [{
        "user_name" => "渡部　ケント",
        "user_name_kana" => "ワタベ　ケント",
        "email" => "watanabe@example.com",
        "position" => "担当部長",
        "department" => "経営企画部",
        "contact_tel" => "09044209999",
      }]
    }
  end
end
