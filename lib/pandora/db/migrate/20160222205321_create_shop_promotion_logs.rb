class CreateShopPromotionLogs < ActiveRecord::Migration
  def change
    create_table :shop_promotion_logs do |t|
      t.integer :c_id
      t.integer :shop_id
      t.text :content
      t.timestamps :null => false
    end
    add_index :shop_promotion_logs, :c_id
    add_index :shop_promotion_logs, :shop_id
    add_foreign_key "shop_promotion_logs", "shops", :column => "shop_id"
    add_foreign_key "shop_promotion_logs", "commissioners", :column => "c_id"
  end
end
