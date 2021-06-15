class CreatePermissionTables < ActiveRecord::Migration[5.2]
  def change
    create_table :sb_user_permissions do |t|
      t.integer :internal_user_id, null: false, comment: "内部ユーザーID"
      t.integer :sb_user_position_id, null: false, comment: "権限ID"
      t.boolean :available, null: false, default: true, comment: "利用可能か"
      t.timestamps null: false
    end
  end
end
