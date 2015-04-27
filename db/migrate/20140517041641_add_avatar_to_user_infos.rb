class AddAvatarToUserInfos < ActiveRecord::Migration
  def change
  	add_column :user_infos, :avatar, :string
  end
end
