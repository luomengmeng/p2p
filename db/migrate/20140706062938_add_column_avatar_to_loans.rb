class AddColumnAvatarToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :avatar, :string
  end
end
