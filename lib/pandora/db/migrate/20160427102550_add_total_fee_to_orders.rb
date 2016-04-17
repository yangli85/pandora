class AddTotalFeeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :total_fee, :float, :default => 0, :null => false
  end
end
