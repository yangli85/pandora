class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.string :gender, :default => :unknow
      t.string :phone_number, :null => false, primary_key: true
      t.integer :avatar
      t.integer :vitality, :default => 0
      t.timestamps :null => false
    end
    add_index :users, :phone_number
  end
end
