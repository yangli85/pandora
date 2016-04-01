class CreatePaymentLogs < ActiveRecord::Migration
  def change
    create_table :payment_logs, id: false do |t|
      t.string :out_trade_no, :null => false
      t.string :trade_no
      t.string :subject
      t.string :trade_status, :default => :CREATED, :null => false
      t.string :seller_id
      t.string :seller_email
      t.string :buyer_id
      t.string :buyer_email
      t.float :total_fee
      t.string :plat_form
      t.integer :order_id, :null => false
      t.timestamps :null => false
    end
    add_foreign_key "payment_logs", "orders", :column => "order_id"
    execute "ALTER TABLE payment_logs ADD PRIMARY KEY (out_trade_no);"
  end
end
