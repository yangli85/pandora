class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :category, :default => :unknow, :null => false
      t.string :url, :null => false
      t.integer :s_image_id
      t.timestamps :null => false
    end
  end
end
