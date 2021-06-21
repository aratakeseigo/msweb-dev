FactoryBot.define do
  factory :sb_guarantee_exam do
    transaction_contents { "取扱い商品" } # 取扱い商品
    payment_method_id { PaymentMethod.all.sample } # 決済条件
    payment_method_optional { "決済条件補足" } # 決済条件補足
    new_transaction { true } # 取引
    transaction_years { 3 } # 取引歴
    payment_delayed { true } # 支払い遅延
    payment_delayed_memo { "支払い遅延の状況" } # 支払い遅延の状況
    payment_method_changed { true } # 支払条件変更
    payment_method_changed_memo { "支払条件変更内容" } # 支払条件変更内容
    other_companies_ammount { "ＡＢ蛇内保証会社" } # 保証会社名
    other_guarantee_companies { "900000" } # 保証額
    guarantee_amount_hope { "5000000" } # 保証希望額
  end
end
