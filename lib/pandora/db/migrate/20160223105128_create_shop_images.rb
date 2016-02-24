class CreateShopImages < ActiveRecord::Migration
  def change
    create_table :shop_images do |t|
      t.integer :shop_id
      t.integer :image_id
      t.timestamps :null => false
    end
    add_index :shop_images, :image_id
    add_index :shop_images, :shop_id
    add_foreign_key "shop_images", "shops", :column => "shop_id"
    add_foreign_key "shop_images", "images", :column => "image_id"
  end
end
