class CreateLoginUsers < ActiveRecord::Migration
  def change
    create_table :login_users,id: false do |t|
      t.integer :user_id
      t.string :access_token
      t.timestamps :null => false
    end
    add_index :login_users, :user_id
    add_foreign_key "login_users", "users", :column => "user_id"

    execute "ALTER TABLE login_users ADD PRIMARY KEY (user_id);"
  end
end
