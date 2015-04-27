class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :user_id
      t.decimal :amount, :precision => 31, :scale => 17
      t.decimal :available_amount, :precision => 31, :scale => 17
      t.integer :months
      t.float :interest
      t.string :repay_style
      t.decimal :min_invest, :precision => 31, :scale => 17
      t.decimal :max_invest, :precision => 31, :scale => 17
      t.datetime :due_date
      t.string :title
      t.text :desc
      t.string :credit_level
      t.boolean :with_mortgage
      t.boolean :with_guarantee
      t.string :state
      t.integer :junior_auditor_id
      t.datetime :junior_audit_time
      t.integer :senior_auditor_id
      t.datetime :senior_audit_time
      t.integer :bids_auditor_id
      t.datetime :bids_audit_time

      t.timestamps
    end
    add_index :loans, :user_id
    add_index :loans, :with_mortgage
    add_index :loans, :with_guarantee
    add_index :loans, :state
  end
end
