class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :words
      t.string :css
      t.timestamps
    end
  end
end
