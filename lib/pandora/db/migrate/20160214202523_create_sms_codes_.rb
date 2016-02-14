class CreateSmsCodes < ActiveRecord::Migration
  def change
    create_table :sms_codes do |t|
      t.string :phone_number, :null => false, primary_key: true
      t.string :code, :null => false
      t.timestamps :null => false
    end
    add_index :sms_codes, :phone_number
  end
end
