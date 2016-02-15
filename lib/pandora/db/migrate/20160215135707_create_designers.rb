class CreateDesigners < ActiveRecord::Migration
  def change
    create_table :designers do |t|
      t.integer :user_id, :null=> false, primary_key: true
      t.integer :shop_id
      t.boolean :is_vip, :default => false
      t.datetime :expired_at
      t.integer :stars
      t.integer :likes
      t.timestamps :null => false
    end
    add_index :designers, :user_id
    add_index :designers, :shop_id
    add_foreign_key "designers", "users", :column => "user_id"
    add_foreign_key "designers", "shops", :column => "shop_id"
  end
end
