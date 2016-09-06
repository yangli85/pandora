class AddIndexToDesigners < ActiveRecord::Migration
  def change
    add_index :designers, :monthly_stars
    add_index :designers, :weekly_stars
    add_index :designers, :totally_stars
  end
end
