class CreateOfflineRecharges < ActiveRecord::Migration
  def change
    create_table :offline_recharges do |t|
      t.integer :user_id
      t.integer :offline_bank_id
      t.decimal :amount
      t.string :comment
      t.integer :auditor_id
      t.string :auditor_commnet
      t.datetime :audit_time
      t.integer :status

      t.timestamps null: false
    end
  end
end
