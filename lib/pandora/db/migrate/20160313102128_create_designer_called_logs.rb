class CreateDesignerCalledLogs < ActiveRecord::Migration
  def change
    create_table :designer_called_logs do |t|
      t.integer :user_id
      t.integer :designer_id
      t.timestamps :null => false
    end
    add_index :designer_called_logs, :user_id
    add_index :designer_called_logs, :designer_id
    add_foreign_key "designer_called_logs", "users", :column => "user_id"
    add_foreign_key "designer_called_logs", "designers", :column => "designer_id"
  end
end
