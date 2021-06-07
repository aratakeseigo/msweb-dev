class ChangeAmountColumnsToSbClient < ActiveRecord::Migration[5.2]
  def up
    change_column :sb_clients, :capital, :bigint, comment: "資本金"
    change_column :sb_clients, :annual_sales, :bigint, comment: "年商"
  end

  def down
    change_column :sb_clients, :capital, :integer, comment: "資本金"
    change_column :sb_clients, :annual_sales, :integer, comment: "年商"
  end
end
