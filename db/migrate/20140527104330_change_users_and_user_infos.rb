class ChangeUsersAndUserInfos < ActiveRecord::Migration
  def change
  	add_column :users, :auth_realname, :boolean
  	add_column :user_infos, :idcard_pic, :string
  end
end
