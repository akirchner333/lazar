class ReplyJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :plies_replies, id: false do |t|
      t.belongs_to :ply, class_name: "Post"
      t.belongs_to :reply, class_name: "Post"
    end
  end
end
