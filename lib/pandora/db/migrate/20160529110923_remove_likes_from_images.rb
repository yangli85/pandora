class RemoveLikesFromImages < ActiveRecord::Migration
  def up
    remove_column :images, :likes
  end

  def down
    add_column :images, :likes, :integer
  end
end
