class AlterTwitterContentEncoding < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE twitters MODIFY COLUMN content text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
    SQL
  end

  def down
  end
end
