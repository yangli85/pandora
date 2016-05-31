class AlterVitaeEncoding < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE vitae CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
    SQL
  end

  def down
  end
end
