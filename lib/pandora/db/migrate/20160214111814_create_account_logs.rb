class CreateAccountLogs < ActiveRecord::Migration
  def change
    create_table :account_logs do |t|
      t.integer :account_id
      t.integer :balance
      t.string :event, :default => :unknow, :null => false
      t.string :channel, :default => :beautyshow, :null => false
      t.integer :from_user
      t.integer :to_user
      t.string :desc
      t.timestamps :null => false
    end
    add_foreign_key "account_logs", "accounts", :column => "account_id"
    add_foreign_key "account_logs", "users", :column => "from_user"
    add_foreign_key "account_logs", "users", :column => "to_user"
    add_index :account_logs, :account_id
  end
end
