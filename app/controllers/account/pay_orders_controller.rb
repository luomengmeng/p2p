# encoding: utf-8
class Account::PayOrdersController < Account::BaseController

  # 充值记录
  def index
    @pay_orders = current_user.pay_orders.succeed.order('id desc').paginate :page => params[:page], :per_page => 20
    @title = '管理角色'
  end

  # 充值
  def new
    @pay_orders = current_user.pay_orders.succeed.order('id desc').paginate :page => params[:page], :per_page => 20
    @title = '充值'
    @pay_order = PayOrder.new
  end

  #offline_bank
  def offline_bank
  end
  #offline_recharge
  def offline_recharge
  end


  def create
    if (params[:pay_order][:amount].to_f < 10)
      flash[:error] = "最小充值金额为10元"
      redirect_to :back
      return
    end
    @pay_money = params[:pay_order][:amount].to_f
    pay_order = current_user.pay_orders.create( :amount => @pay_money,
                                                :callback_path => account_recharge_path,
                                                :callback_model => current_user,
                                                :callback_model_method => "nil?")
    if pay_order.errors.blank?
      if !Utils.production?
        pay_url = "http://" + request.host_with_port + "/user/finish_payment/#{pay_order.uuid}/#{params[:pay_order][:pay_class]}/0"
      else
        callback = "http://" + request.host_with_port + "/user/finish_payment/#{pay_order.uuid}"
        pay_url = ThirdPay.request_url(params["pay_order"]["pay_class"], pay_order, callback)
      end
      redirect_to pay_url
    else
      flash[:error] = pay_order.errors
      redirect_to :back
    end
  end

end