class RemoveColumnApproveIdToSbClient < ActiveRecord::Migration[5.2]
  def change
    remove_column :sb_clients, :approval_id
  end
end
