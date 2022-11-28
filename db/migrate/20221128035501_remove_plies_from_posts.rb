class RemovePliesFromPosts < ActiveRecord::Migration[7.0]
  def change
    drop_table :plies_replies

    add_reference :posts, :posts
    # add a column for parents
    # add_column :posts, :generation, :integer, default: 5
  end
end
