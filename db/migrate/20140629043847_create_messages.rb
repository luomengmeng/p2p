class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :send_user_id
      t.integer :receive_user_id
      t.string :title
      t.text :content
      t.integer :status
      t.string :type
      t.text :reply
      t.datetime :replytime
      t.boolean :deleted

      t.timestamps
    end
  end
end
