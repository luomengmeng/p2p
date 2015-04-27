class CreateRepayments < ActiveRecord::Migration
  def change
    create_table :repayments do |t|
      t.integer :loan_id
      t.integer :user_id
      t.decimal :amount, :precision => 31, :scale => 17
      t.decimal :principal, :precision => 31, :scale => 17
      t.decimal :left_principal, :precision => 31, :scale => 17
      t.decimal :interest_amount, :precision => 31, :scale => 17
      t.integer :month_index
      t.integer :late_days
      t.string :state, :default => 'unpaid'
      t.datetime :due_date
      t.datetime :paid_at
      t.boolean :paid_by_platform, :default => false

      t.timestamps
    end
  end
end
