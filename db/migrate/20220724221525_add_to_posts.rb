class AddToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :generation, :integer, default: 5
  end
end
