class AddColumnNoticeToWithdraws < ActiveRecord::Migration
  def change
    add_column :withdraws, :notice, :text
  end
end
