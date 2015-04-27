class CreateOfflineBanks < ActiveRecord::Migration
  def change
    create_table :offline_banks do |t|
      t.integer :creator_id
      t.string :name
      t.string :detail
      t.string :status

      t.timestamps null: false
    end
  end
end
