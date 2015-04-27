class AddColumnEstimatedTimeAndCodeToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :avatar_display, :boolean
    add_column :loans, :estimated_time, :datetime
    add_column :loans, :code, :string
  end
end
