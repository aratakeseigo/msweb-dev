FactoryBot.define do
  factory :accs_bl_info, class: AccsBlInfo do
    sequence(:bi_serial_number) { |n| n }
    corporate_code { |n| "KG#{sprintf("%09d", n)}" }
  end
end