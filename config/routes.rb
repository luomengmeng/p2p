require 'resque/server'
Lending::Application.routes.draw do

  devise_for :users, controllers: { :registrations => "registrations", :sessions => "sessions", :passwords => "passwords", :confirmations => "confirmations"}
  devise_scope :user do
    get "admins", to: "sessions#new", :role => "admin"
  end
  root :to => 'home#index'

  mount ChinaCity::Engine => '/china_city'

  mount Resque::Server, :at => "/resque"

  #mount MongodbLogger::Server.new, :at => "/system_logger", :as => :mongodb
  #mount MongodbLogger::Assets.instance, :at => "/system_logger/assets", :as => :mongodb_assets # assets

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:is_admin?) && current_user.is_admin?
  end

  constraints resque_web_constraint do
    ResqueWeb::Engine.eager_load!
    mount ResqueWeb::Engine => "/resque_web"
  end

  # 我要理财
  resources :invests do
    collection do
      get :search
      get :info_json
      get :search_json
      get 'show_invest'
    end
  end

  # 债权转让
  resources :debts do
    collection do
      get :debt_json
      get :show_debts
    end
  end


  # 收益计算器
  get 'calculator', to: 'invests#calculator'

  # 我要借款
  get 'loan', to: 'loans#new'

  namespace :account do

    # 我的账户
    resource :users do
      # 个人主页
      get :show
      get :show_json

      # 实名认证
      get :real_name

      # 手机认证
      get :auth_phone
      get :auth_email

      # 发送验证码
      get :send_verify_code

      # 验证手机号
      post :verify_phone

      # 个人设置
      get :profile

      get :show_set_password
      get :show_set_trade_password

      post :set_password
      post :set_trade_password
    end

    # 交易记录
    get 'transactions', to: 'cash_flows#index'

    # 充值
    get 'recharge', to: 'pay_orders#new'
    post 'recharge', to: 'pay_orders#create'

    # 充值记录
    get 'recharges', to: 'pay_orders#index'

    # 提现
    resources :withdraws

    # 银行卡管理
    resources :banks, controller: 'user_banks'

    # 理财管理
    resources :invests, controller: 'bids' do
      collection do
        get :stat # 理财统计
        get :repaying
        get :finished
      end
    end

    resources :debts do
      collection do
        get :selling_list
        get :sold
      end

      member do
        get :sell
        put :hawk
        put :cancel_hawk
      end
    end

    # 自动投标
    resources :auto_invests

    # 收款明细
    resources :collections

    #协议
    resources :contracts

    #站内消息
    resources :messages

    # 邀请管理
    resources :promotions

  end
  namespace :user do
    get 'finish_payment/:id/:pay_class/:notice_from', to: 'payments#finish'
    post 'finish_payment/:id/:pay_class/:notice_from', to: 'payments#finish'
  end
  resources :home do
    collection do
      get :company_info
      get :info_json
      get :basic_info_json
      get :banner_info
    end
  end
  resources :guides
  resources :helps
  resources :loan_applications

  resources :webnews

  resources :downloads
end
