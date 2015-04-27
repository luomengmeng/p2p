class CreatePropagandas < ActiveRecord::Migration
  def change
    create_table :propagandas do |t|
    	t.string :name
    	t.integer :position

      t.timestamps
    end
  end
end
