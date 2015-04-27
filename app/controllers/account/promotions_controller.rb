# encoding: utf-8
class Account::PromotionsController < Account::BaseController

  # 投标记录
  def index
    @search  = current_user.bids.search(params[:search])
  end

end