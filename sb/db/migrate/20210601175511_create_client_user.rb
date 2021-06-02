class CreateClientUser < ActiveRecord::Migration[5.2]
  def change
    create_table :client_users do |t|
      t.references :client, foreign_key: true,  null: false
      t.string :tanto_name
      t.string :tanto_kana
      t.string :email
      t.string :department
      t.string :position
      t.string :tel
      t.timestamps
    end
  end
end
