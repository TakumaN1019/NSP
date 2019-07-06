class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :text
      t.string :image
      t.integer :user_id

      t.timestamps
    end
  end
end
