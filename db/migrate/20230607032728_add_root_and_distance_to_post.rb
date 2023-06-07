class AddRootAndDistanceToPost < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :root
    remove_reference :posts, :posts
    add_reference :posts, :parent
    add_column :posts, :distance, :integer, default: 0
  end
end
