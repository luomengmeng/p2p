class CreateAutoInvestRules < ActiveRecord::Migration
  def change
    create_table :auto_invest_rules do |t|
      t.integer :user_id
      t.float :amount
      t.float :min_interest
      t.float :max_interest
      t.integer :min_months
      t.integer :max_months
      t.string :credit_level
      t.boolean :with_mortgage
      t.boolean :with_guarantee
      t.string :repay_style
      t.float :remain_amount
      t.datetime :actived_at

      t.timestamps
    end
    add_index :auto_invest_rules, :user_id
    add_index :auto_invest_rules, :actived_at
  end
end
