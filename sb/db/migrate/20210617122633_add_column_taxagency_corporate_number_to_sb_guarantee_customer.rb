class AddColumnTaxagencyCorporateNumberToSbGuaranteeCustomer < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_guarantee_customers, :taxagency_corporate_number, :string, comment: "保証元法人番号"
  end
end
