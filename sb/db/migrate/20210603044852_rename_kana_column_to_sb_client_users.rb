class RenameKanaColumnToSbClientUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :sb_client_users, :kana, :name_kana
    change_column_comment :sb_client_users, :name_kana, "担当者名カナ"
  end
end
