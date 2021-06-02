class CreateSbClientUser < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_client_users do |t|
      t.references :sb_client, foreign_key: true, null: false
      t.string :name
      t.string :kana
      t.string :email
      t.string :department
      t.string :position
      t.string :contact_tel
      t.timestamps
    end
  end
end
