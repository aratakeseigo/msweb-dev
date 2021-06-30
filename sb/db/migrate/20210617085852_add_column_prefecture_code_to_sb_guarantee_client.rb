class AddColumnPrefectureCodeToSbGuaranteeClient < ActiveRecord::Migration[5.2]
  def change
    add_column :sb_guarantee_clients, :prefecture_code, :integer, comment: "都道府県"
  end
end
