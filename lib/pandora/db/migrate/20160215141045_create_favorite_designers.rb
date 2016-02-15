class CreateFavoriteDesigners < ActiveRecord::Migration
  def change
    create_table :favarite_designers do |t|
      t.integer :user_id, :null => false
      t.integer :designer_id, :null => false
      t.timestamps :null => false
    end
    add_index :favarite_designers, :user_id
    add_index :favarite_designers, :designer_id
    add_foreign_key "favarite_designers", "users", :column => "user_id"
    add_foreign_key "favarite_designers", "users", :column => "designer_id"
  end
end
