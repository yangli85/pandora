class CreatePromotionLogs < ActiveRecord::Migration
  def change
    create_table :promotion_logs do |t|
      t.string :phone_number
      t.string :mobile_type,:default => 'unknow'
      t.integer :c_id
      t.timestamps :null => false
    end
    add_index :promotion_logs, :c_id
    add_foreign_key "promotion_logs", "commissioners", :column => "c_id"
  end
end
