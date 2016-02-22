class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :category, :default => :unknow, :null => false
      t.string :url, :null => false
      t.integer :original_image_id
      t.timestamps :null => false
    end
    add_foreign_key "images", "images", :column => "original_image_id"
  end
end
