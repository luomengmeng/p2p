class AddColumnLoanStateIdToLoans < ActiveRecord::Migration

  def up
    change_table :loans do |t|
      t.column :loan_state_id, :integer
      t.remove :state
    end
  end
 
  def down
    change_table :loans do |t|
      t.remove :loan_state_id
      t.column :state, :string
    end
  end
end
