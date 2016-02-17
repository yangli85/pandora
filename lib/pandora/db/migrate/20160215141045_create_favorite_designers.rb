class CreateFavoriteDesigners < ActiveRecord::Migration
  def change
    create_table :favorite_designers do |t|
      t.integer :user_id, :null => false
      t.integer :designer_id, :null => false
      t.timestamps :null => false
    end
    add_index :favorite_designers, :user_id
    add_index :favorite_designers, :designer_id
    add_foreign_key "favorite_designers", "users", :column => "user_id"
    add_foreign_key "favorite_designers", "designers", :column => "designer_id"
  end
end
