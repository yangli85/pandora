class AddForeignKeyAvatarToUsers < ActiveRecord::Migration
  def change
    add_foreign_key "users", "images", :column => "avatar"
  end
end
