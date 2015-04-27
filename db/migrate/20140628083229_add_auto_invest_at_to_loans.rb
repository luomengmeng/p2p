class AddAutoInvestAtToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :auto_invested_at, :datetime
  end
end
