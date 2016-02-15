class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :gender, :default => :unknow
      t.string :phone_number, :null => false
      t.integer :image_id
      t.integer :vitality, :default => 0
      t.string :status, :default => :nomal
      t.timestamps :null => false
    end
    add_index :users, :phone_number
    add_foreign_key "users", "images", :column => "image_id"
  end
end
