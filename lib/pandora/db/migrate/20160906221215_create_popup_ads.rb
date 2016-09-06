class CreatePopupAds < ActiveRecord::Migration
  def change
    create_table :popup_ads do |t|
      t.string :image_url, :null => false
      t.string :link, :null => false
      t.string :category, :null => false, :default => :unknow
    end
  end
end
