class ChangAuthRealname < ActiveRecord::Migration
  def change
  	remove_column :users, :auth_realname
  	add_column :users, :auth_realname, :integer
  end
end
