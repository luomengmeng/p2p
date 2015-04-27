class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :user_id
      t.integer :loan_id
      t.decimal :invest_amount, :precision => 31, :scale => 17
      t.integer :invest_month
      t.float :interest
      t.decimal :collection_amount, :precision => 31, :scale => 17
      t.decimal :colected_amount, :precision => 31, :scale => 17
      t.decimal :collected_interest, :precision => 31, :scale => 17
      t.decimal :not_collected_amount, :precision => 31, :scale => 17
      t.decimal :not_collected_interest, :precision => 31, :scale => 17
      t.string :status

      t.timestamps
    end
    add_index :bids, :user_id
    add_index :bids, :loan_id
    add_index :bids, :status
  end
end
