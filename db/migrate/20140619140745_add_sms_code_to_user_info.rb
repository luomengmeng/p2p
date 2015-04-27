class AddSmsCodeToUserInfo < ActiveRecord::Migration
  def up
    add_column :user_infos, :sms_verify_code, :string
    add_column :users, :auth_mobile, :boolean, :default => false
  end

  def down
    remove_column :user_infos, :sms_verify_code
    remove_column :users, :auth_mobile
  end
end
