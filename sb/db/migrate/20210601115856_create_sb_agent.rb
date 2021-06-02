class CreateSbAgent < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_agents, comment: "SB代理店" do |t|
      t.integer :entity_id, null: false, comment: "法人ID"
      t.string :name, null: false, comment: "代理店名"
      t.timestamps
    end
  end
end
