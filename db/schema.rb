# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150420054846) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.boolean  "is_top",        default: false
    t.boolean  "is_home",       default: false
    t.integer  "status",        default: 1
    t.integer  "propaganda_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_nav",      default: false
  end

  add_index "articles", ["propaganda_id"], name: "index_articles_on_propaganda_id", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "auto_invest_rules", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.float    "min_interest"
    t.float    "max_interest"
    t.integer  "min_months"
    t.integer  "max_months"
    t.string   "credit_level"
    t.boolean  "with_mortgage"
    t.boolean  "with_guarantee"
    t.string   "repay_style"
    t.float    "remain_amount"
    t.datetime "actived_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "auto_invest_rules", ["actived_at"], name: "index_auto_invest_rules_on_actived_at", using: :btree
  add_index "auto_invest_rules", ["user_id"], name: "index_auto_invest_rules_on_user_id", using: :btree

  create_table "banners", force: :cascade do |t|
    t.string   "title"
    t.string   "pic"
    t.text     "inner_html"
    t.integer  "weight"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bids", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "loan_id"
    t.decimal  "invest_amount",          precision: 31, scale: 17
    t.integer  "invest_month"
    t.float    "interest"
    t.decimal  "collection_amount",      precision: 31, scale: 17
    t.decimal  "colected_amount",        precision: 31, scale: 17
    t.decimal  "collected_interest",     precision: 31, scale: 17
    t.decimal  "not_collected_amount",   precision: 31, scale: 17
    t.decimal  "not_collected_interest", precision: 31, scale: 17
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "from_bid_id"
    t.boolean  "for_sale",                                         default: false
    t.datetime "for_sale_time"
    t.integer  "for_sale_month"
    t.decimal  "for_sale_amount",        precision: 16, scale: 2
    t.decimal  "sold_amount",            precision: 16, scale: 2
    t.boolean  "auto_invest",                                      default: false
  end

  add_index "bids", ["loan_id"], name: "index_bids_on_loan_id", using: :btree
  add_index "bids", ["status"], name: "index_bids_on_status", using: :btree
  add_index "bids", ["user_id"], name: "index_bids_on_user_id", using: :btree

  create_table "cash_flows", force: :cascade do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "offline_user_id"
    t.decimal  "amount",                   precision: 31, scale: 17
    t.string   "trigger_type"
    t.integer  "trigger_id"
    t.integer  "cash_flow_description_id"
    t.integer  "pay_order_id"
    t.string   "pay_class"
    t.string   "addition"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total_of_from_user",       precision: 31, scale: 17
    t.decimal  "available_of_from_user",   precision: 31, scale: 17
    t.decimal  "freeze_of_from_user",      precision: 31, scale: 17
    t.decimal  "total_of_to_user",         precision: 31, scale: 17
    t.decimal  "available_of_to_user",     precision: 31, scale: 17
    t.decimal  "freeze_of_to_user",        precision: 31, scale: 17
  end

  add_index "cash_flows", ["cash_flow_description_id"], name: "index_cash_flows_on_cash_flow_description_id", using: :btree
  add_index "cash_flows", ["from_user_id", "to_user_id"], name: "index_cash_flows_on_from_user_id_and_to_user_id", using: :btree
  add_index "cash_flows", ["from_user_id"], name: "index_cash_flows_on_from_user_id", using: :btree
  add_index "cash_flows", ["to_user_id"], name: "index_cash_flows_on_to_user_id", using: :btree

  create_table "collections", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "bid_id"
    t.integer  "repayment_id"
    t.integer  "borrower_id"
    t.decimal  "amount",       precision: 31, scale: 17
    t.decimal  "principal",    precision: 31, scale: 17
    t.decimal  "interest",     precision: 31, scale: 17
    t.datetime "due_date"
    t.datetime "paid_at"
    t.integer  "month_index"
    t.string   "repay_state",                            default: "unpaid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "removed",                                default: false
  end

  add_index "collections", ["bid_id"], name: "index_collections_on_bid_id", using: :btree
  add_index "collections", ["borrower_id"], name: "index_collections_on_borrower_id", using: :btree
  add_index "collections", ["repay_state"], name: "index_collections_on_repay_state", using: :btree
  add_index "collections", ["repayment_id"], name: "index_collections_on_repayment_id", using: :btree
  add_index "collections", ["user_id"], name: "index_collections_on_user_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "relation"
    t.string   "name"
    t.string   "mobile"
    t.string   "company"
    t.string   "job_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dictionaries", force: :cascade do |t|
    t.string   "type"
    t.string   "name"
    t.string   "code"
    t.integer  "position"
    t.string   "introduction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "downloads", force: :cascade do |t|
    t.string   "name"
    t.string   "file"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendlinks", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.integer  "weight",     default: 0
    t.integer  "status",     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kindeditor_assets", force: :cascade do |t|
    t.string   "asset"
    t.integer  "file_size"
    t.string   "file_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loan_applications", force: :cascade do |t|
    t.decimal  "amount",          precision: 31, scale: 17
    t.string   "loan_usage"
    t.string   "name"
    t.string   "id_card"
    t.string   "phone"
    t.string   "email"
    t.string   "register_addr"
    t.string   "addr"
    t.decimal  "monthly_income",  precision: 31, scale: 17
    t.decimal  "monthly_expense", precision: 31, scale: 17
    t.string   "company"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "loans", force: :cascade do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.float    "available_amount"
    t.integer  "months"
    t.float    "interest"
    t.string   "repay_style"
    t.float    "min_invest"
    t.float    "max_invest"
    t.datetime "due_date"
    t.string   "title"
    t.text     "desc"
    t.string   "credit_level"
    t.boolean  "with_mortgage"
    t.boolean  "with_guarantee"
    t.integer  "junior_auditor_id"
    t.datetime "junior_audit_time"
    t.integer  "senior_auditor_id"
    t.datetime "senior_audit_time"
    t.integer  "bids_auditor_id"
    t.datetime "bids_audit_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loan_state_id"
    t.datetime "auto_invested_at"
    t.string   "avatar"
    t.boolean  "avatar_display"
    t.datetime "estimated_time"
    t.string   "code"
  end

  add_index "loans", ["user_id"], name: "index_loans_on_user_id", using: :btree
  add_index "loans", ["with_guarantee"], name: "index_loans_on_with_guarantee", using: :btree
  add_index "loans", ["with_mortgage"], name: "index_loans_on_with_mortgage", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "send_user_id"
    t.integer  "receive_user_id"
    t.string   "title"
    t.text     "content"
    t.integer  "status"
    t.string   "type"
    t.text     "reply"
    t.datetime "replytime"
    t.boolean  "deleted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offline_banks", force: :cascade do |t|
    t.integer  "creator_id"
    t.string   "name"
    t.string   "detail"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offline_recharges", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "offline_bank_id"
    t.decimal  "amount"
    t.string   "comment"
    t.integer  "auditor_id"
    t.string   "auditor_commnet"
    t.datetime "audit_time"
    t.integer  "status"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pay_orders", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.string   "payment_serial"
    t.string   "bank_order_id"
    t.string   "callback_path"
    t.string   "callback_model_name"
    t.integer  "callback_model_id"
    t.string   "callback_model_method"
    t.decimal  "amount",                precision: 16, scale: 2
    t.boolean  "paid",                                           default: false
    t.boolean  "success"
    t.integer  "pay_method_id"
    t.string   "pay_class"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pay_orders", ["pay_class"], name: "index_pay_orders_on_pay_class", using: :btree
  add_index "pay_orders", ["user_id"], name: "index_pay_orders_on_user_id", using: :btree
  add_index "pay_orders", ["uuid"], name: "index_pay_orders_on_uuid", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "action"
    t.string   "subject"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", id: false, force: :cascade do |t|
    t.integer "permission_id"
    t.integer "role_id"
  end

  add_index "permissions_roles", ["permission_id", "role_id"], name: "index_permissions_roles_on_permission_id_and_role_id", using: :btree
  add_index "permissions_roles", ["role_id", "permission_id"], name: "index_permissions_roles_on_role_id_and_permission_id", using: :btree

  create_table "propagandas", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "weight",     default: 0
  end

  create_table "repayments", force: :cascade do |t|
    t.integer  "loan_id"
    t.integer  "user_id"
    t.decimal  "amount",           precision: 31, scale: 17
    t.decimal  "principal",        precision: 31, scale: 17
    t.decimal  "left_principal",   precision: 31, scale: 17
    t.decimal  "interest_amount",  precision: 31, scale: 17
    t.integer  "month_index"
    t.integer  "late_days"
    t.string   "state",                                      default: "unpaid"
    t.datetime "due_date"
    t.datetime "paid_at"
    t.boolean  "paid_by_platform",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.boolean  "is_admin",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "system_configs", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.text     "description"
    t.integer  "changer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "editable",    default: true
  end

  create_table "user_banks", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "card_number"
    t.string   "bank"
    t.string   "branch"
    t.string   "province"
    t.string   "city"
    t.string   "area"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_banks", ["card_number"], name: "index_user_banks_on_card_number", using: :btree
  add_index "user_banks", ["user_id"], name: "index_user_banks_on_user_id", using: :btree

  create_table "user_cashes", force: :cascade do |t|
    t.integer  "user_id"
    t.decimal  "total",                    precision: 31, scale: 17
    t.decimal  "available",                precision: 31, scale: 17
    t.decimal  "freeze_amount",            precision: 31, scale: 17
    t.decimal  "not_collection_total",     precision: 31, scale: 17
    t.decimal  "not_collection_interest",  precision: 31, scale: 17
    t.decimal  "collected_interest",       precision: 31, scale: 17
    t.decimal  "withdraw_total",           precision: 31, scale: 17
    t.decimal  "withdraw_received",        precision: 31, scale: 17
    t.decimal  "withdraw_fee",             precision: 31, scale: 17
    t.decimal  "not_repay_total",          precision: 31, scale: 17
    t.decimal  "invest_total",             precision: 31, scale: 17
    t.decimal  "loan_total",               precision: 31, scale: 17
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "not_collection_principal", precision: 31, scale: 17
    t.decimal  "recharge_total",           precision: 31, scale: 17
  end

  add_index "user_cashes", ["user_id"], name: "index_user_cashes_on_user_id", using: :btree

  create_table "user_infos", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "id_card"
    t.integer  "marriage_type_id"
    t.string   "child"
    t.integer  "education_type_id"
    t.integer  "degree_type_id"
    t.string   "phone"
    t.string   "mobile"
    t.string   "postcode"
    t.string   "province"
    t.string   "city"
    t.string   "area"
    t.string   "detailed_address"
    t.string   "qq"
    t.integer  "income"
    t.boolean  "social_security"
    t.string   "social_security_id"
    t.string   "housing"
    t.string   "car"
    t.text     "house_address"
    t.string   "house_area"
    t.string   "house_year"
    t.text     "house_status"
    t.string   "house_holder1"
    t.string   "house_holder2"
    t.string   "house_right1"
    t.string   "house_right2"
    t.string   "house_loanyear"
    t.string   "house_loanprice"
    t.string   "house_balance"
    t.string   "house_bank"
    t.string   "company_name"
    t.string   "company_type"
    t.string   "company_industry"
    t.string   "company_job"
    t.string   "company_title"
    t.string   "company_worktime1"
    t.string   "company_worktime2"
    t.string   "company_phone"
    t.string   "company_address"
    t.string   "company_weburl"
    t.string   "company_reamrk"
    t.string   "mate_name"
    t.string   "mate_id_card"
    t.string   "mate_salary"
    t.string   "mate_phone"
    t.string   "mate_mobile"
    t.string   "mate_company_name"
    t.string   "mate_job"
    t.string   "mate_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.string   "idcard_pic"
    t.integer  "gender_id"
    t.string   "sms_verify_code"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "",    null: false
    t.string   "encrypted_password",       default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_trade_password"
    t.boolean  "auth_mobile",              default: false
    t.integer  "auth_realname"
    t.string   "username"
    t.integer  "from_user_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "web_statistics", force: :cascade do |t|
    t.string   "title"
    t.text     "code"
    t.integer  "status",     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "withdraws", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "status",                                    default: "auditing"
    t.decimal  "amount",          precision: 31, scale: 17
    t.decimal  "received_amount", precision: 31, scale: 17
    t.decimal  "fee",             precision: 31, scale: 17
    t.string   "card_number"
    t.string   "bank"
    t.string   "branch"
    t.string   "province"
    t.string   "city"
    t.string   "area"
    t.integer  "auditor_id"
    t.datetime "audit_time"
    t.text     "audit_comment"
    t.string   "pay_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notice"
  end

  add_index "withdraws", ["auditor_id"], name: "index_withdraws_on_auditor_id", using: :btree
  add_index "withdraws", ["pay_class"], name: "index_withdraws_on_pay_class", using: :btree
  add_index "withdraws", ["status"], name: "index_withdraws_on_status", using: :btree
  add_index "withdraws", ["user_id"], name: "index_withdraws_on_user_id", using: :btree

end
