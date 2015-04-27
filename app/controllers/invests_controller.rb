# encoding: utf-8
class InvestsController < ApplicationController
  before_filter :authenticate_user!, :verify_lender, :only => [:new, :create]
  include ApplicationHelper
  # 我要理财
  def info_json
    @loans = Loan.bidding_or_after.order('id desc').paginate :page => params[:page], :per_page => 10
    @title = '我要理财'
    
    loan_infos = {}
    @loans.each_with_index do |loan, index|
      loan_infos.merge!((index.to_s).to_sym => {id: loan.id, amount: loan.amount, state: loan.state.name, title: loan.title, name: loan.borrower.name, progress: loan.progress, interest: loan.interest, months: loan.months, available_amount: loan.available_amount})
    end

    info = {
            invest_people: User.lender.count,
            invest_amount: rmb_wan(Loan.total_amount),
            total_deal_num: Loan.count,
            interest_amount: rmb_wan(Collection.sum(:interest)),
            total_pages: @loans.total_pages,
            current_page: @loans.current_page,
            loans: loan_infos
    }
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  def index
    redirect_to '/loans'
    return
    @loans = Loan.bidding_or_after.order('id desc').paginate :page => params[:page], :per_page => 10
    #binding.pry
    @title = '我要理财'

  end


  # 投标详情
  def show
    redirect_to "/show_invest?id=#{params[:id]}"
    return
    # @loan = Loan.can_be_seen.find(params[:id])
    # @bid = Bid.new(:user => current_user, :loan_id => @loan.id)
    # @total = 0
    # @interest = Loan.calculator(@loan.repay_style, 100, @loan.months, @loan.interest)
    # @interest.values.each{|v| @total += (v[:seed] + v[:interest])}
    # @earnings_tmp = @total - 100
    # @title = '我要理财'
  end

  def show_invest
    @loan = Loan.can_be_seen.find(params[:id])
    @bid = Bid.new(:user => current_user, :loan_id => @loan.id)
    @total = 0
    @interest = Loan.calculator(@loan.repay_style, 100, @loan.months, @loan.interest)
    @interest.values.each{|v| @total += (v[:seed] + v[:interest])}
    @earnings_tmp = @total - 100
    @title = '我要理财'
    if @loan.loan_state_id == Dict::LoanState.bidding.id && @loan.due_date.present? && @loan.due_date > DateTime.now
      due_at = @loan.due_date.strftime("%Y,%m,%d")
    else
      due_at = 0
    end
    repaystyle = {"equal"=>"按月分期还款", "interest_only"=>"按月还息，到期还本", "at_due"=>"到期归还本息"}
    info = {
        cash_account: current_user.present? ? rmb(current_user.user_cash.available.to_f) : 0 ,
        must_be_login: must_be_login,
        current_user: current_user.present? ? 1:0,
        loan_state_id:Dict::LoanState.bidding.id,
        due_at: due_at,
        total_deal_num:123,
        collection_amount: @bid.collection_amount,
        earnings_tmp: @earnings_tmp,
        interest: @interest,
        loan: @loan,
        bid: @bid,
        repayment_methods: repaystyle[@loan.repay_style].to_s,
        state_name: @loan.state.name
    }
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  # 投资
  def new
    @bid = Bid.new(:user => current_user,
                   :loan_id => params[:loan_id])
    @loan = Loan.can_be_seen.find(params[:loan_id])
    @title = '我要理财'
    render layout: false
  end

  def create
    if params[:bid][:invest_amount].to_f > current_user.user_cash.available.to_f
      redirect_to "/show_invest?id=#{params[:bid][:loan_id]}&errors=账户余额不足"
      return
    end
    loan = Loan.can_be_seen.find(params[:bid][:loan_id])

    if loan.min_invest.present? && params[:bid][:invest_amount].to_f < loan.min_invest
      redirect_to "/show_invest?id=#{params[:bid][:loan_id]}&errors=投资金额不能小于#{loan.min_invest}"
      return
    end

    if loan.min_invest.present? && (loan.available_amount < 2 * loan.min_invest) && (params[:bid][:invest_amount].to_f < loan.available_amount)
      redirect_to "/show_invest?id=#{params[:bid][:loan_id]}&errors=当前标的可投金额为#{loan.available_amount}元，请一次投满。"
      return
    end

    if loan.max_invest.present? && loan.min_invest.present? && params[:bid][:invest_amount].to_f > (loan.max_invest - loan.min_invest) && params[:bid][:invest_amount].to_f < loan.max_invest
      params[:bid][:invest_amount] = loan.max_invest - loan.min_invest
    end

    if loan.max_invest.present? && params[:bid][:invest_amount].to_f > loan.max_invest
      params[:bid][:invest_amount] = loan.max_invest
    end

    if params[:bid][:invest_amount].to_f > loan.available_amount
      params[:bid][:invest_amount] = loan.available_amount
    end

    begin
      Bid.create_by_user current_user, params[:bid][:loan_id], params[:bid][:invest_amount]
      redirect_to "/show_invest?id=#{params[:bid][:loan_id]}&notice=投标成功"
    rescue Exception => ex

      @loan = Loan.can_be_seen.find(params[:bid][:loan_id])
      @bid = Bid.new(:user => current_user,
                     :loan_id => params[:bid][:loan_id])
      redirect_to "/show_invest?id=#{params[:bid][:loan_id]}&errors=#{ex.message}"
    end
  end

  # 投资计算器
  def calculator
    if params[:type].present?
      @apr_month = params[:apr].to_f/12
      @total = 0
      @interest = Loan.calculator(params[:type], params[:account], params[:times], params[:apr])
      @interest.values.each{|v| @total += (v[:seed] + v[:interest])}
    end
  end

  def verify_lender
    redirect_to root_url unless current_user.roles.is_lender.present?
  end

  def search_json
    current_page = params[:page].present? ? params[:page] : 1
    interest = params['interest'].present? && params['interest'] != 'all' ?
        { interest: params['interest'] } : nil
    months = nil
    if params['months'].present? && params['months'].to_i >0
      get_months = params['months'].to_i
      months = get_months < 6 ?  ['months = ?' ,get_months] : ["months >= ?",get_months]
    end
    with_change = nil
    if params['biao_type'].present? && params['biao_type'] != 'all'
      if params['biao_type'] == 'mortgage'
        with_change = {with_mortgage: true}
      elsif params['biao_type'] == 'guarantee'
        with_change = {with_guarantee: true}
      end
    end

    if params['loan_state_id'].present? && params['loan_state_id'] != 'all'
      loans = Loan.where({loan_state_id: params['loan_state_id'].to_i })
    else
      loans = Loan.bidding_or_after
    end
    @loans = loans.where(interest).where(months).where(with_change).order('id desc').paginate :page => current_page, :per_page => 10

    @title = '我要理财'
    info = {total_pages: @loans.total_pages,
            current_page: current_page,
            loans: @loans}
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end

  end

  def search
    sql = []
    sql << "repay_style = '#{params[:type]}'" if params[:type].present? && !params[:type].nil?
    sql << "credit_level = '#{params[:level]}'" if params[:level].present? && !params[:level].nil?
    if params[:time].present? && !params[:time].nil?
      case params[:time]
      when '1-3'
        sql << "months between 1 and 3"
      when '4-6'
        sql << "months between 4 and 6"
      when '7-12'
        sql << "months between 7 and 12"
      when '12+'
        sql << "months > 12"
      end
    end
    if params[:interest].present? && !params[:interest].nil?
      case params[:interest]
      when '5-10'
        sql << "interest between 5 and 10"
      when '10-15'
        sql << "interest between 10 and 15"
      when '15-20'
        sql << "interest between 15 and 20"
      when '20+'
        sql << "interest > 20"
      end
    end
    sql << "loan_state_id = '#{params[:state]}'" if params[:state].present? && !params[:state].nil?
    @loans = Loan.can_be_seen.where(sql.join(" and ")).order('id desc').paginate :page => params[:page], :per_page => 20
    render :layout => false
  end
end
