# encoding: utf-8
class Backend::AuthRealnamesController < Backend::BaseController
  def index
    # binding.pry
  	case params[:state]
  	when '1'
      @q = Role.find_by_name('投资人').users.auth_realname_pass.order("id desc").ransack(params[:q])
      @lenders = @q.result.paginate :page => params[:page], :per_page => 20
      # @lenders = Role.find_by_name('投资人').users.auth_realname_pass.order("id desc").simple_search(params[:q]).paginate :page => params[:page], :per_page => 20
    when '0'
      @q = Role.find_by_name('投资人').users.auth_realname_reject.order("id desc").ransack(params[:q])
      @lenders = @q.result.paginate :page => params[:page], :per_page => 20
      # @lenders = Role.find_by_name('投资人').users.auth_realname_reject.order("id desc").simple_search(params[:q]).paginate :page => params[:page], :per_page => 20
    when '2'
      @q = Role.find_by_name('投资人').users.auth_realname_ready.order("id desc").ransack(params[:q])
      @lenders = @q.result.paginate :page => params[:page], :per_page => 20
      # @lenders = Role.find_by_name('投资人').users.auth_realname_ready.order("id desc").simple_search(params[:q]).paginate :page => params[:page], :per_page => 20
    else
      @q = Role.find_by_name('投资人').users.auth_realname_notready.order("id desc").ransack(params[:q])
      @lenders = @q.result.paginate :page => params[:page], :per_page => 20
    	# @lenders = Role.find_by_name('投资人').users.auth_realname_notready.order("id desc").simple_search(params[:q]).paginate :page => params[:page], :per_page => 20
    end
    @title = '实名认证管理'
  end

end
