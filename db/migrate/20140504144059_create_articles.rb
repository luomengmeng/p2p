class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
    	t.integer :user_id
      t.string :title
      t.text :content
      t.boolean :is_top, :default => false
      t.boolean :is_home, :default => false
      t.integer :status, :default => 1
      t.integer :propaganda_id
      t.integer :position

      t.timestamps
    end
    add_index :articles, :user_id
    add_index :articles, :propaganda_id
  end
end
