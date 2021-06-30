class RemoveColumnSbGuaranteeClientIdFromSbGuaranteeCustomers < ActiveRecord::Migration[5.2]
  def change
    remove_column :sb_guarantee_customers, :sb_guarantee_client_id
  end
end
