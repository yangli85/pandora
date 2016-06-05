class AlterTwittersEncoding < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER TABLE twitters convert to character set utf8mb4 collate utf8mb4_bin;
    SQL
  end

  def down
  end
end
