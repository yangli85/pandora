class CreateAdImages < ActiveRecord::Migration
  def change
    create_table :ad_images do |t|
      t.string :category
      t.integer :image_id, :null => false
      t.string :event
      t.string :args
      t.timestamps :null => false
    end
    add_index :ad_images, :category
    add_foreign_key "ad_images", "images", :column => "image_id"
  end
end
