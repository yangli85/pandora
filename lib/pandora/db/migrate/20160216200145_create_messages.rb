class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :user_id, :null => false
      t.text :content
      t.boolean :is_new, :default => false
      t.timestamps :null => false
    end
    add_index :messages, :user_id
    add_foreign_key "messages", "users", :column => "user_id"
  end
end
