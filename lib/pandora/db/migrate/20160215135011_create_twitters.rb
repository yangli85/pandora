class CreateTwitters < ActiveRecord::Migration
  def change
    create_table :twitters do |t|
      t.text :content
      t.integer :author_id, :null => false
      t.integer :designer_id, :null => false
      t.string :latitude
      t.string :longtitude
      t.integer :image_count
      t.boolean :deleted, :default => false
      t.integer :stars, :null => false
      t.timestamps :null => false
    end
    add_index :twitters, :author_id
    add_index :twitters, :designer_id
    add_foreign_key "twitters", "users", :column => "author_id"
    add_foreign_key "twitters", "designers", :column => "designer_id"
  end
end
