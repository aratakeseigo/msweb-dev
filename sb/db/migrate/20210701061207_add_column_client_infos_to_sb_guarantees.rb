class AddColumnClientInfosToSbGuarantees < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_guarantees, :client_company_name, :string, comment: "保証元企業名"
    add_column :sb_guarantees, :client_daihyo_name, :string, comment: "保証元代表者名"
  end
end
