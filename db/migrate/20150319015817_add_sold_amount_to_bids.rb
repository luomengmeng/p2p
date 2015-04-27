class AddSoldAmountToBids < ActiveRecord::Migration
  def change
  	add_column :bids, :sold_amount, :decimal, :precision => 16, :scale => 2
  end
end
