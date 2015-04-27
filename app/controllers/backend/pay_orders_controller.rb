# encoding: utf-8
class Backend::PayOrdersController < Backend::BaseController

  # 充值记录
  def index
    # binding.pry
    @search = PayOrder.order("id desc").ransack(params[:q])
    @pay_orders = @search.result.paginate(:page => params[:page], :per_page => 20)
    @title = '线上充值记录'
  end

  # 充值管理
  def manage
    @search = Role.find_by_name('投资人').users.order("id desc").joins(:info).ransack(params[:q])
    if params[:search].present?
      @lenders = @search.result.paginate(:page => params[:page], :per_page => 20)
    end
    @offline_recharge = CashFlow.with_description(Dict::CashFlowDescription.offline_recharge).order('created_at desc').paginate :page => params[:page], :per_page => 20
    @title = '线下充值'
  end

  # 线下充值
  def offline_recharge
    @user = User.find(params[:id])
    @offline_recharge = @user.cash_flows.order('created_at desc').with_description(Dict::CashFlowDescription.offline_recharge).paginate :page => params[:page], :per_page => 20
    @title = '线下充值'
  end

  def create_offline_recharge
    if params[:amount].to_f == 0.0
      redirect_to :back
      return
    end
    CashFlow.transaction do
      user = User.find(params[:user_id])
      CashFlow.recharge_for user, params[:amount].to_f, nil, '', Dict::CashFlowDescription.offline_recharge
    end
    redirect_to offline_recharge_backend_pay_orders_path(:id => params[:user_id])
  end

  def download
    if params[:printout].present?
      Spreadsheet.client_encoding = 'UTF-8'
      book = Spreadsheet::Workbook.new
      @pay_orders = PayOrder.order("id desc").find(params[:printout])
      sheet1 = book.create_worksheet
      sheet1.row(0).push("编号", "邮箱", "姓名", "金额", "创建时间", "更新时间", "成功")
      @pay_orders.each_with_index do |order, i|
        sheet1.row(i + 1).push(
          order.id,
          order.user.email,
          order.user.name,
          order.amount,
          order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
          order.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
          (order.success ? '是' : '否')
        )
      end
      str_io = StringIO.new
      book.write(str_io)
      send_data(str_io.string, :filename => "pay_orders#{Time.now.strftime('%x')}.xls" )
    else
      flash[:errors] = "请至少选择一项"
      redirect_to :back
    end
  end

end