class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name, :null => false
      t.string :address, :null => false
      t.string :latitude, :null => false
      t.string :longtitude, :null => false
      t.string :scale
      t.string :category
      t.boolean :deleted,:default => false
      t.text :desc
      t.integer :created_by
      t.integer :updated_by
      t.timestamps :null => false
    end
  end
end
