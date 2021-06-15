class AddApplovalToSbClient < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_clients, :approval_id, :integer, comment: "決裁ID"
  end
end
