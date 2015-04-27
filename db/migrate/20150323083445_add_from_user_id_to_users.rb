class AddFromUserIdToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :from_user_id, :integer
  end
end
