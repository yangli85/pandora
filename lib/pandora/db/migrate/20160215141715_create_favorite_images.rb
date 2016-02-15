class CreateFavoriteImages < ActiveRecord::Migration
  def change
    create_table :favarite_images do |t|
      t.integer :user_id, :null => false
      t.integer :image_id, :null => false
      t.timestamps :null => false
    end
    add_index :favarite_images, :user_id
    add_index :favarite_images, :image_id
    add_foreign_key "favarite_images", "users", :column => "user_id"
    add_foreign_key "favarite_images", "images", :column => "image_id"
  end
end
