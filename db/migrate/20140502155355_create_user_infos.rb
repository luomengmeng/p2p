class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.integer :user_id
      t.string :name
      t.string :id_card

      t.integer :marriage_type_id
      t.string :child
      t.integer :education_type_id
      t.integer :degree_type_id
      t.string :phone
      t.string :mobile
      t.string :postcode
      t.string :province
      t.string :city
      t.string :area
      t.string :detailed_address
      t.string :qq

      t.integer :income
      t.boolean :social_security
      t.string :social_security_id

      t.string :housing
      t.string :car
      t.text :house_address
      t.string :house_area
      t.string :house_year
      t.text :house_status
      t.string :house_holder1
      t.string :house_holder2
      t.string :house_right1
      t.string :house_right2
      t.string :house_loanyear
      t.string :house_loanprice
      t.string :house_balance
      t.string :house_bank

      t.string :company_name
      t.string :company_type
      t.string :company_industry
      t.string :company_job
      t.string :company_title
      t.string :company_worktime1
      t.string :company_worktime2
      t.string :company_phone
      t.string :company_address
      t.string :company_weburl
      t.string :company_reamrk

      t.string :mate_name
      t.string :mate_id_card
      t.string :mate_salary
      t.string :mate_phone
      t.string :mate_phone
      t.string :mate_mobile
      t.string :mate_company_name
      t.string :mate_job
      t.string :mate_address



      t.timestamps
    end
  end
end