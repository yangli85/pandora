class CreateCommissioners < ActiveRecord::Migration
  def change
    create_table :commissioners do |t|
      t.string :phone_number, :null => false
      t.string :name
      t.string :password, :default => '888888', :limit => 10
      t.integer :code_image_id
      t.string :status, :default => 'normal'
      t.timestamps :null => false
    end
    add_index :commissioners, :phone_number
    add_foreign_key "commissioners", "images", :column => "code_image_id"
  end
end
