class ChangeColumnSbClients < ActiveRecord::Migration[5.2]
  def up
    change_column :sb_clients, :entity_id, :integer, null: true, comment: "法人ID"
  end

  def down
    change_column :sb_clients, :entity_id, :integer, null: false
  end
end
