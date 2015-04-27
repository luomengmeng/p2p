class AddColumnToPropagandas < ActiveRecord::Migration
  def change
  	add_column :propagandas, :parent_id, :integer
  	add_column :propagandas, :weight, :integer, :default => 0
  	add_column :articles, :show_nav, :boolean, :default => false
  end
end
