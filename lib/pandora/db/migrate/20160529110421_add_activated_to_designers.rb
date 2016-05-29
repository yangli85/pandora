class AddActivatedToDesigners < ActiveRecord::Migration
  def change
    add_column :designers, :activated, :boolean, :default => false, :null => false
  end
end