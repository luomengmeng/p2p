class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries do |t|
      t.string :type
      t.string :name
      t.string :code
      t.integer :position
      t.string :introduction

      t.timestamps
    end
  end
end
