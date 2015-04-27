class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :title
      t.string :pic
      t.text :inner_html
      t.integer :weight
      t.boolean :status

      t.timestamps
    end
  end
end
