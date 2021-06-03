class CreateSbClientUser < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_client_users, comment: "SBクライアントユーザー" do |t|
      t.references :sb_client, foreign_key: true, null: false, comment: "SBクライアントID"
      t.string :name, null: false, comment: "担当者名"
      t.string :kana, comment: "担当者名カナ"
      t.string :email, comment: "メールアドレス"
      t.string :department, comment: "部署"
      t.string :position, comment: "役職"
      t.string :contact_tel, comment: "希望連絡先"
      t.timestamps
    end
  end
end
