class CreateClient < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :client_name
      t.integer :area_code
      t.integer :sb_user_id
      t.string :daihyo_name
      t.string :zip_code
      t.integer :prefecture_code
      t.string :address1 
      t.string :address2
      t.string :tel
      t.string :industry_code1
      t.string :industry_code2
      t.timestamps
    end
  end
end
