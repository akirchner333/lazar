class CreatePubFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :pub_followers do |t|
      t.string :follower
      t.string :actor_url
      t.belongs_to :user, null: true
      t.timestamps
    end
  end
end
