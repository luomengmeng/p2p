class CreateUserBanks < ActiveRecord::Migration
  def change
    create_table :user_banks do |t|
      t.integer :user_id
      t.string :card_number
      t.string :bank
      t.string :branch
      t.string :province
      t.string :city
      t.string :area

      t.timestamps
    end

    add_index :user_banks, :user_id
    add_index :user_banks, :card_number
  end
end
