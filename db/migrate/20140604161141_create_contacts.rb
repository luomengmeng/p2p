class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.integer :user_id
      t.string :relation
      t.string :name
      t.string :mobile
      t.string :company
      t.string :job_title

      t.timestamps
    end
  end
end
