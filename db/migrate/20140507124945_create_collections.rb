class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.integer :user_id
      t.integer :bid_id
      t.integer :repayment_id
      t.integer :borrower_id
      t.decimal :amount, :precision => 31, :scale => 17
      t.decimal :principal, :precision => 31, :scale => 17
      t.decimal :interest, :precision => 31, :scale => 17
      t.datetime :due_date
      t.datetime :paid_at
      t.integer :month_index
      t.string :repay_state, :default => 'unpaid'

      t.timestamps
    end
    add_index :collections, :user_id
    add_index :collections, :bid_id
    add_index :collections, :repayment_id
    add_index :collections, :borrower_id
    add_index :collections, :repay_state
  end
end
