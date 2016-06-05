class AlterVitaeEncoding < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE vitae convert to character set utf8mb4 collate utf8mb4_bin;
    SQL
  end

  def down
  end
end
