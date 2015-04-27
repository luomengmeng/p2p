# encoding: utf-8
include ApplicationHelper
class Account::UsersController < Account::BaseController

  # 我的账户
  def show
    @bids = current_user.bids.status_in(['bidding', 'bids_auditing']).order("created_at desc").limit(3)
    @loans = Loan.bidding_or_after.order('id desc').limit(4)
    @title = '我的账户'
  end

  def show_json
    bids = current_user.bids.status_in(['bidding', 'bids_auditing']).order("created_at desc").limit(5)
    @loans = Loan.bidding_or_after.order('id desc').limit(4)
    @title = '我的账户'
    avatar_url = current_user.info.avatar.present? ? current_user.info.avatar.url : 'image/xtouxiang.jpg'
    bids = bids.present? ? bids : 0
    logger.info "#{bids}"
    info = {
        total_amount: (rmb current_user.total_amount),
        available: (rmb current_user.available),
        freeze_amount: (rmb current_user.freeze_amount),
        email: current_user.confirmed_at.present? ? 1 : 0,
        user: current_user,
        avatar_url: avatar_url,
        title: @title,
        bids: bids,
        loans: @loans
    }
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  #个人信息
  # def profile 
  #   @title = '个人信息'
  #   @user=User.new
  #   @user.save
  # end
  # 实名认证
  def real_name
  end

  def auth_phone
  end

  def auth_email
  end

  def send_verify_code
    # 生成验证码
    verify_code = current_user.info.generate_sms_verify_code(params[:mobile])

    # 发送验证码
    # res = Sms.send_verify_code(params[:mobile], verify_code)
    res = Resque.enqueue(SmsJob, :send_verify_code, params[:mobile], verify_code)
    render :text => res
  end

  def verify_phone
    if params[:user_info][:sms_verify_code] == current_user.info.sms_verify_code && params[:user_info][:mobile] == current_user.info.mobile
      current_user.pass_auth_mobile
    else
      flash[:errors] = '验证码错误'
    end
    redirect_to :back
  end

  # 个人设置
  # def profile
  # end

  # 登录密码
  def show_set_password
  end

  def set_password
    pwd=BCrypt::Password.new(current_user.encrypted_password)
    if pwd == params[:old_password]
    	if current_user.update_attributes(info_params_password)
  			flash[:success] = '密码修改成功，请重新登录。'
  			redirect_to user_session_path
  		else
  			flash[:errors] = current_user.errors
  			render :show_set_password
  		end
    else
      flash[:errors] = "旧密码不正确！"
      render :show_set_password
    end

  end

  def show_set_trade_password
  end

  def set_trade_password
    if !current_user.encrypted_trade_password.present? or current_user.trade_password == params[:old_trade_password] or current_user.info.sms_verify_code == params[:old_trade_password]
      if current_user.update_attribute(:trade_password, params[:user][:trade_password])
        flash[:success] = '提现密码修改成功'
        redirect_to :action => :show_set_trade_password
      else
        flash[:errors] = @user.errors
        render :show_set_trade_password
      end
    else
      flash[:errors] = "旧提现密码不正确！"
      render :show_set_trade_password
    end

  end

  def update
    @info = current_user.info
    if @info.update_attributes(info_params)
      current_user.check_auth_realname
			flash[:success] = '修改成功'
			redirect_to :back
		else
			flash[:errors] = @info.errors
			redirect_to :back
		end

  end

  def recharge
  end

  private

  def info_params
    params.require(:user_info).permit(:name, :id_card, :idcard_pic, :mobile, :phone, :postcode, :detailed_address, :qq, :avatar, :password, :password_confirmation, :sms_verify_code)
  end
  def info_params_password
    params.require(:user_info).permit(:password, :password_confirmation)
  end

end