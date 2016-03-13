class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name, :null => false
      t.string :address, :null => false
      t.string :province, :null => false
      t.string :city, :null => false
      t.string :latitude, :null => false
      t.string :longitude, :null => false
      t.string :scale
      t.string :category
      t.boolean :deleted, :default => false
      t.text :desc
      t.timestamps :null => false
    end
  end
end
