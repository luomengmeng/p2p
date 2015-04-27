# encoding: utf-8
class Backend::AutoInvestRulesController < Backend::BaseController
  def index
    @roles = AutoInvestRule.order('id desc').paginate :page => params[:page], :per_page => 20
    @title = '管理自动投标'
  end

  # 执行自动投标
  def execute
    AutoInvestRule.exec_for(Loan.find(params[:id]))
    redirect_to :back
  end

end