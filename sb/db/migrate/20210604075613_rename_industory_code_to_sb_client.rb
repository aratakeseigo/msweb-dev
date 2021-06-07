class RenameIndustoryCodeToSbClient < ActiveRecord::Migration[5.2]
  def change
    rename_column :sb_clients, :industry_code, :industry_id
    change_column_comment :sb_clients, :industry_id, "業種コード"
  end
end
