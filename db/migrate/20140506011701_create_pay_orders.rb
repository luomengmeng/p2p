class CreatePayOrders < ActiveRecord::Migration
  def change
    create_table :pay_orders do |t|
      t.integer :user_id
      t.string :uuid
      t.string :payment_serial
      t.string :bank_order_id
      t.string :callback_path
      t.string :callback_model_name
      t.integer :callback_model_id
      t.string :callback_model_method
      t.decimal :amount, :precision => 16, :scale => 2
      t.boolean :paid, :default => false
      t.boolean :success
      t.integer :pay_method_id
      t.string :pay_class

      t.timestamps
    end

    add_index :pay_orders, :uuid
    add_index :pay_orders, :user_id
    add_index :pay_orders, :pay_class
  end
end
