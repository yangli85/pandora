class CreatePaymentLogs < ActiveRecord::Migration
  def change
    create_table :payment_logs,id: false do |t|
      t.string :out_trade_no, :null => false
      t.integer :user_id, :null => false
      t.string :trade_no
      t.string :subject
      t.string :trade_status, :default => :CREATED, :null => false
      t.string :seller_id
      t.string :seller_email
      t.string :buyer_id
      t.string :buyer_email
      t.integer :total_fee
      t.string :plat_form
      t.timestamps :null => false
    end
    execute "ALTER TABLE payment_logs ADD PRIMARY KEY (out_trade_no);"
  end
end
