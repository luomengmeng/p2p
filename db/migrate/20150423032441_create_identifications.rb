class CreateIdentifications < ActiveRecord::Migration
  def change
    create_table :identifications do |t|
      t.integer :user_id
      t.string :category
      t.string :desc
      t.string :file

      t.timestamps null: false
    end
  end
end
