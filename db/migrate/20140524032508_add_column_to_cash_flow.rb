class AddColumnToCashFlow < ActiveRecord::Migration
  def change
    add_column :cash_flows, :total_of_from_user, :decimal, :precision => 31, :scale => 17
    add_column :cash_flows, :available_of_from_user, :decimal, :precision => 31, :scale => 17
    add_column :cash_flows, :freeze_of_from_user, :decimal, :precision => 31, :scale => 17

    add_column :cash_flows, :total_of_to_user, :decimal, :precision => 31, :scale => 17
    add_column :cash_flows, :available_of_to_user, :decimal, :precision => 31, :scale => 17
    add_column :cash_flows, :freeze_of_to_user, :decimal, :precision => 31, :scale => 17

    remove_column :cash_flows, :from_user_left_amount
  end
end
