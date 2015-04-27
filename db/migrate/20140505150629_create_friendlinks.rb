class CreateFriendlinks < ActiveRecord::Migration
  def change
    create_table :friendlinks do |t|
    	t.string :url
    	t.string :title
    	t.integer :weight, :default => 0
    	t.integer :status, :default => 1

      t.timestamps
    end
  end
end
