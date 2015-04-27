class CreateLoanApplications < ActiveRecord::Migration
  def change
    create_table :loan_applications do |t|
    	t.decimal :amount, :precision => 31, :scale => 17
    	t.string :loan_usage
    	t.string :name
    	t.string :id_card
    	t.string :phone
    	t.string :email
    	t.string :register_addr
    	t.string :addr
    	t.decimal :monthly_income, :precision => 31, :scale => 17
    	t.decimal :monthly_expense, :precision => 31, :scale => 17
    	t.string :company
    	t.string :title

      t.timestamps
    end
  end
end
