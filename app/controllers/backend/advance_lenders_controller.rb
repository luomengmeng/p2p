# encoding: utf-8

class Backend::AdvanceLendersController < Backend::BaseController
  def index
    if params[:q].present?
      @lenders = Role.find_by_name('投资人').users.order("created_at desc").simple_search(params[:q]).paginate(:page => params[:page], :per_page => 20)
    else
      @lenders = Role.find_by_name('投资人').users.order("created_at desc").paginate(:page => params[:page], :per_page => 20)
    end
  end

  def show
    @lender = User.find(params[:id])
    @cash_flows = @lender.cash_flows.order("created_at desc").paginate :page => params[:page1], :per_page => 20
    @upcomings = @lender.collections.unpaid.order("due_date").paginate :page => params[:page2], :per_page => 20
    @bids = @lender.bids.order("created_at desc").paginate :page => params[:page3], :per_page => 20
  end

  def auth_realname_pass
    @lender = User.find(params[:id])
    return render :json => @lender.auth_realname_pass(params[:pass])
  end

end
