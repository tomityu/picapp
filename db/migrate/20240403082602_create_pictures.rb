class CreatePictures < ActiveRecord::Migration[7.1]
  def change
    create_table :pictures do |t|
      t.references :user, foreign_key: true, null: false
      t.string :path, null: false
      t.integer :point, null: false, default: 0

      t.timestamps
    end
  end
end
