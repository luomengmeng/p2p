class ChangeColumnTypeInLoan < ActiveRecord::Migration
  def up
    change_column :loans, :amount, :float
    change_column :loans, :available_amount, :float
    change_column :loans, :min_invest, :float
    change_column :loans, :max_invest, :float
  end

  def down
    change_column :loans, :amount, :precision => 31, :scale => 17
    change_column :loans, :available_amount, :precision => 31, :scale => 17
    change_column :loans, :min_invest, :precision => 31, :scale => 17
    change_column :loans, :max_invest, :precision => 31, :scale => 17
  end
end
