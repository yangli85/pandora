class CreateTwitterImages < ActiveRecord::Migration
  def change
    create_table :twitter_images do |t|
      t.integer :twitter_id, :null => false
      t.integer :image_id, :null => false
      t.integer :likes, :default => 0
      t.integer :rank, :null => false
      t.timestamps :null => false
    end
    add_index :twitter_images, :twitter_id
    add_foreign_key "twitter_images", "images", :column => "image_id"
    add_foreign_key "twitter_images", "twitters", :column => "twitter_id"
  end
end
