class CreateVitae < ActiveRecord::Migration
  def change
    create_table :vitae do |t|
      t.integer :designer_id, :null => false
      t.text :desc
      t.timestamps :null => false
    end
    add_index :vitae, :designer_id
    add_foreign_key "vitae", "designers", :column => "designer_id"
  end
end
