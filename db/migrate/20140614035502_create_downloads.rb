class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
    	t.string :name
    	t.string :file
    	t.text :description

      t.timestamps
    end
  end
end
