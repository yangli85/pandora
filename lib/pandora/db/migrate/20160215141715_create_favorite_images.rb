class CreateFavoriteImages < ActiveRecord::Migration
  def change
    create_table :favorite_images do |t|
      t.integer :user_id, :null => false
      t.integer :image_id, :null => false
      t.timestamps :null => false
    end
    add_index :favorite_images, :user_id
    add_index :favorite_images, :image_id
    add_foreign_key "favorite_images", "users", :column => "user_id"
    add_foreign_key "favorite_images", "images", :column => "image_id"
  end
end
