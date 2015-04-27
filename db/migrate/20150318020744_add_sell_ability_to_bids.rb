class AddSellAbilityToBids < ActiveRecord::Migration
  def change
  	add_column :bids,:from_bid_id,:integer
  	add_column :bids,:for_sale,:boolean, :default => false
  	add_column :bids,:for_sale_time,:timestamp
  	add_column :bids,:for_sale_month,:integer
  	add_column :bids,:for_sale_amount, :decimal, :precision => 16, :scale => 2
  end
end
