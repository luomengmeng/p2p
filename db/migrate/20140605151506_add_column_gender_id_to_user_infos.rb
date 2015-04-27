class AddColumnGenderIdToUserInfos < ActiveRecord::Migration
  def change
    add_column :user_infos, :gender_id, :integer
  end
end
