class AddColumnEncryptedTradePasswordToUsers < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_trade_password, :string
  end
end
