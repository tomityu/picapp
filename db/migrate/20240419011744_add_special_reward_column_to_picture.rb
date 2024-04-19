class AddSpecialRewardColumnToPicture < ActiveRecord::Migration[7.1]
  def change
    add_column :pictures, :spesial_reward, :bool, null: false, default: false
  end
end
