class CreatePressures < ActiveRecord::Migration[5.2]
  def change
    create_table :pressures do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.string :direction

      t.timestamps
    end
  end
end
