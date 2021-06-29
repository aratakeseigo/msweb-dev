class ChangeColumnIndustryId < ActiveRecord::Migration[5.2]
  def change
    change_column :sb_clients, :industry_id, :integer, comment: "業種ID"
  end
end
