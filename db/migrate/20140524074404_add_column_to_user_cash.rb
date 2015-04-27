class AddColumnToUserCash < ActiveRecord::Migration
  def change
    add_column :user_cashes, :not_collection_principal, :decimal, :precision => 31, :scale => 17
    add_column :user_cashes, :recharge_total, :decimal, :precision => 31, :scale => 17
  end
end
