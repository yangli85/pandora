class CreateTwitters < ActiveRecord::Migration
  def change
    create_table :twitters do |t|
      t.text :content
      t.integer :author, :null => false
      t.integer :designer, :null => false
      t.string :latitude
      t.string :longtitude
      t.integer :image_count
      t.boolean :deleted, :default => false
      t.integer :stars
      t.timestamps :null => false
    end
    add_index :twitters, :author
    add_index :twitters, :designer
    add_foreign_key "twitters", "users", :column => "author"
    add_foreign_key "twitters", "designers", :column => "designer"
  end
end
