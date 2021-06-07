class AddColumnsCreatedByAndUpdateByToSbClient < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_clients, :created_by, :integer, null: false, comment: "作成者"
    add_column :sb_clients, :updated_by, :integer, null: false, comment: "更新者"
  end
end
