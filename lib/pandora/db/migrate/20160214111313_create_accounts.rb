class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :user_id
      t.integer :balance, :default => 0
      t.timestamps :null => false
    end
    add_foreign_key "accounts", "users", :column => "user_id"
    add_index :accounts, :user_id
  end
end
