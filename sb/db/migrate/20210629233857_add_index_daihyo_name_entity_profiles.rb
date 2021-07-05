class AddIndexDaihyoNameEntityProfiles < ActiveRecord::Migration[5.2]
  def change
    add_index :entity_profiles, :daihyo_name, name: "IDX_EP_DAIHYO_NAME"
  end
end
