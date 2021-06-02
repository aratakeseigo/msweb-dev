class CreateSbClient < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_clients do |t|
      t.integer :entity_id, null: false
      t.string :name, null: false
      t.integer :status_id
      t.string :taxagency_corporate_number
      t.integer :area_id
      t.integer :sb_user_id
      t.string :daihyo_name, null: false
      t.string :zip_code
      t.integer :prefecture_code
      t.string :address 
      t.string :tel
      t.string :industry_code1
      t.string :industry_code2
      t.string :established
      t.integer :annual_sales
      t.integer :channel_id
      t.references :sb_agent, foreign_key: true
      t.boolean :anti_social_check, default: false
      t.text :content
      t.timestamps
    end
  end
end
