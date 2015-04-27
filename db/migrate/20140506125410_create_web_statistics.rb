class CreateWebStatistics < ActiveRecord::Migration
  def change
    create_table :web_statistics do |t|
    	t.string :title
    	t.text :code
    	t.integer :status, :default => 1

      t.timestamps
    end
  end
end
