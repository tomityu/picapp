class RemoveColumnFromPicture < ActiveRecord::Migration[7.1]
  def change
    remove_column :pictures, :path
  end
end
