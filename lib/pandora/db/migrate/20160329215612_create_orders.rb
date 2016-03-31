class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :product, :null => false
      t.integer :count, :null => false
      t.integer :user_id, :null => false
      t.text :result
      t.string :status, :default => :CREATED
      t.timestamps :null => false
    end
    add_foreign_key "orders", "users", :column => "user_id"
    add_index :orders, :user_id
  end
end
