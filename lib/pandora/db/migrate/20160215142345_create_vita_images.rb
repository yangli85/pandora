class CreateVitaImages < ActiveRecord::Migration
  def change
    create_table :vita_images do |t|
      t.integer :vita_id, :null => false
      t.integer :image_id, :null => false
      t.timestamps :null => false
    end
    add_index :vita_images, :vita_id
    add_foreign_key "vita_images", "vitae", :column => "vita_id"
    add_foreign_key "vita_images", "images", :column => "image_id"
  end
end
