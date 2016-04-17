class RemoveTotalFeeFromPaymentLogs < ActiveRecord::Migration
  def up
    remove_column :payment_logs, :total_fee
  end

  def down
    add_column :payment_logs, :total_fee, :float
  end
end
