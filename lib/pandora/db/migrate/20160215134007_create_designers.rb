class CreateDesigners < ActiveRecord::Migration
  def change
    create_table :designers do |t|
      t.integer :user_id, :null => false
      t.integer :shop_id
      t.boolean :is_vip, :default => false
      t.datetime :expired_at
      t.integer :totally_stars, :default => 0
      t.integer :monthly_stars, :default => 0
      t.integer :weekly_stars, :default => 0
      t.integer :likes, :default => 0
      t.timestamps :null => false
    end
    add_index :designers, :user_id
    add_index :designers, :shop_id
    add_foreign_key "designers", "users", :column => "user_id"
    add_foreign_key "designers", "shops", :column => "shop_id"
  end
end
