class AddAutoInvestToBids < ActiveRecord::Migration
  def change
  	add_column :bids, :auto_invest, :boolean, :default => false
  end
end
