class AddDestroyedToCollections < ActiveRecord::Migration
  def change
  	add_column :collections, :removed, :boolean, :default => false
  end
end
