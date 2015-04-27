class AddLogoToFriendlinks < ActiveRecord::Migration
  def change
    add_column :friendlinks, :logo, :string
  end
end
