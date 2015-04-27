# encoding: utf-8
Lending::Application.routes.draw do
  namespace :backend do

    resources :home
    resources :password
    resources :admins
    resources :users do
      collection do
        post :create_user_info
      end
      member do
        get :change_avatar
      end
      resources :identifications do
      end
    end
    resources :loans do
      member do
        post :submit_audit
      end
    end
    resources :audits do
      member do
        get :junior_audit
        get :senior_audit
        get :details
        post :junior_audit_pass
        post :senior_audit_pass
        post :start_bidding
        post :bids_auditing_pass
        post :fail_bid
      end
    end
    resources :roles do
      collection do
        get :edit_multiple
        put :update_multiple
      end
    end

    resources :permissions
    resources :propagandas
    resources :articles
    resources :friendlinks do
      collection do
        post :set_weight
      end
    end
    resources :bids do
      collection do
        get :belongs_to_loan
        get :selling, :sold
      end
    end
    resources :web_statistics do
      collection do
        get :investment_statistics
        get :bid_statistics
        get :borrow_statistics
      end
    end
    resources :lenders do
      collection do
        #get :auth_realname_pass
      end
    end
    resources :advance_lenders do
      collection do
        get :auth_realname_pass
      end
    end

    resources :cash_flows
    resources :messages

    resources :pay_orders do
      collection do
        get :manage
        get :offline_recharge
        post :create_offline_recharge, :download
      end
    end

    # 提现处理
    resources :withdraws do
      member do
        post :set_notice
      end
      collection do
        post :download
      end
    end

    resources :loan_applications do
      collection do
        post :download
      end
    end

    resources :repayments

    # 协议
    resources :protocols
    # get 'protocol/:type', to: 'protocols#show', as: 'protocol'

    resources :system_configs do
      collection do
        get :site_avaliable, :promotion, :prize
        post :close_site
        put :update_promotion, :update_prize
      end
    end

    resources :banners do
      collection do
        post :set_weight
      end
    end

    resources :auto_invest_rules do
      collection do
        post :execute
      end
    end

    resources :downloads

    resources :auth_mobiles

    resources :auth_realnames

    resources :organizations

  end

end
