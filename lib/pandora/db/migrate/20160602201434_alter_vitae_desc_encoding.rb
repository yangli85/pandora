class AlterVitaeDescEncoding < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE vitae MODIFY COLUMN `desc` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
    SQL
  end

  def down
  end
end
