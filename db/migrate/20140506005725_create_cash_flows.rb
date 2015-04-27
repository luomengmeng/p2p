class CreateCashFlows < ActiveRecord::Migration
  def change
    create_table :cash_flows do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.integer :offline_user_id
      t.decimal :amount, :precision => 31, :scale => 17
      t.decimal :from_user_left_amount, :precision => 31, :scale => 17
      t.string :trigger_type
      t.integer :trigger_id
      t.integer :cash_flow_description_id
      t.integer :pay_order_id
      t.string :pay_class
      t.string :addition

      t.timestamps
    end
    add_index :cash_flows, :from_user_id
    add_index :cash_flows, :to_user_id
    add_index :cash_flows, [:from_user_id, :to_user_id]
    add_index :cash_flows, :cash_flow_description_id
  end
end
