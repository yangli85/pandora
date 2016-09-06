class CreateSharedTwitters < ActiveRecord::Migration
  def change
    create_table :shared_twitters do |t|
      t.integer :twitter_id, :null => false
      t.integer :user_id, :null => false
      t.string :channel, :null => false, :default => :unknow
    end
    add_index :shared_twitters, :user_id
    add_index :shared_twitters, :twitter_id
    add_foreign_key "shared_twitters", "users", :column => "user_id"
    add_foreign_key "shared_twitters", "twitters", :column => "twitter_id"
  end
end
