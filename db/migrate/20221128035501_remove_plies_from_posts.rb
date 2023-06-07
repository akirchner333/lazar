class RemovePliesFromPosts < ActiveRecord::Migration[7.0]
  def change
    drop_table :plies_replies
    # add a column for parents
    add_reference :posts, :posts
  end
end
