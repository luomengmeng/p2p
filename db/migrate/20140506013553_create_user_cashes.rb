class CreateUserCashes < ActiveRecord::Migration
  def change
    create_table :user_cashes do |t|
      t.integer :user_id
      t.decimal :total, :precision => 31, :scale => 17
      t.decimal :available, :precision => 31, :scale => 17
      t.decimal :freeze_amount, :precision => 31, :scale => 17
      t.decimal :not_collection_total, :precision => 31, :scale => 17
      t.decimal :not_collection_interest, :precision => 31, :scale => 17
      t.decimal :collected_interest, :precision => 31, :scale => 17
      t.decimal :withdraw_total, :precision => 31, :scale => 17
      t.decimal :withdraw_received, :precision => 31, :scale => 17
      t.decimal :withdraw_fee, :precision => 31, :scale => 17
      t.decimal :not_repay_total, :precision => 31, :scale => 17
      t.decimal :invest_total, :precision => 31, :scale => 17
      t.decimal :loan_total, :precision => 31, :scale => 17

      t.timestamps
    end
    add_index :user_cashes, :user_id
  end
end
