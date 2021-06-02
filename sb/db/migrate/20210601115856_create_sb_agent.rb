class CreateSbAgent < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_agents do |t|
      t.integer :entity_id, null: false
      t.string :name
      t.timestamps
    end
  end
end
