class RenameAntiSocialFlagColumnToSbClient < ActiveRecord::Migration[5.2]
  def change
    rename_column :sb_clients, :anti_social_flag, :anti_social
    rename_column :sb_clients, :established, :established_in
    rename_column :sb_clients, :sb_user_id, :sb_tanto_id
    change_column_comment :sb_clients, :anti_social, "反社(反社の場合true)"
    change_column_comment :sb_clients, :established_in, "設立年月"
    change_column_comment :sb_clients, :sb_tanto_id, "SB担当者ID"
  end
end
