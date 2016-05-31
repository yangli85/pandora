class AlterTwittersEncoding < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE twitters CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
    SQL
  end

  def down
  end
end
