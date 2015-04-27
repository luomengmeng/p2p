# encoding: utf-8
class Backend::CashFlowsController < Backend::BaseController
  def index
    @search = CashFlow.order('id desc').search(params[:search])
    @cash_flows = @search.result.paginate :page => params[:page], :per_page => 20
    @title = '流水明细'
  end

  def show
    @user = User.find params[:id]
    @cash_flows = CashFlow.order("id desc").where(["from_user_id = ? or to_user_id = ?", @user.id, @user.id]).paginate :page => params[:page], :per_page => 20
    @title = '平台流水: ' + @user.name
  end

end