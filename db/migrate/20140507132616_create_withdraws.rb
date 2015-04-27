class CreateWithdraws < ActiveRecord::Migration
  def change
    create_table :withdraws do |t|
      t.integer :user_id
      t.string :status, :default => 'auditing'
      t.decimal :amount, :precision => 31, :scale => 17
      t.decimal :received_amount, :precision => 31, :scale => 17
      t.decimal :fee, :precision => 31, :scale => 17
      t.string :card_number
      t.string :bank
      t.string :branch
      t.string :province
      t.string :city
      t.string :area
      t.integer :auditor_id
      t.datetime :audit_time
      t.text :audit_comment
      t.string :pay_class

      t.timestamps
    end
    add_index :withdraws, :user_id
    add_index :withdraws, :status
    add_index :withdraws, :auditor_id
    add_index :withdraws, :pay_class
  end
end
