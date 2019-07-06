class AddLiveToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :live, :boolean, default: true
  end
end
