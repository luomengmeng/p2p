class CreateSystemConfigs < ActiveRecord::Migration
  def change
    create_table :system_configs do |t|
      t.string :key
      t.string :value
      t.text :description
      t.integer :changer_id

      t.timestamps
    end
  end
end
