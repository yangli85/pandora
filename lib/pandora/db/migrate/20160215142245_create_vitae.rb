class CreateVitae < ActiveRecord::Migration
  def change
    create_table :vitae do |t|
      t.integer :user_id
      t.text :desc
      t.timestamps :null => false
    end
    add_index :vitae, :user_id
    add_foreign_key "vitae", "users", :column => "user_id"
  end
end
