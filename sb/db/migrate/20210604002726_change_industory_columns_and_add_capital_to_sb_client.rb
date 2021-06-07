class ChangeIndustoryColumnsAndAddCapitalToSbClient < ActiveRecord::Migration[5.2]
  def change
    rename_column :sb_clients, :industry_code1, :industry_code
    rename_column :sb_clients, :industry_code2, :industry_optional
    add_column :sb_clients, :capital, :integer, comment: "資本金"
    change_column_comment :sb_clients, :industry_code, "業種コード"
    change_column_comment :sb_clients, :industry_optional, "業種(補足)"
  end
end
