# encoding: utf-8
class HomeController < ApplicationController
  include ApplicationHelper
  # 网站首页
  def index
    @banners = Banner.display
    @loans = Loan.bidding_or_after.order('id desc').limit(5)
    @loans_feature = Loan.going_to_bidding.order('id desc').limit(5)
    @supervise = Propaganda.where(:name => "监管报告").first
    @medias = Propaganda.where(['name = ? or name = ?', '网站公告', '各类常见问题']).limit(2)
    @user = User.new
  end

  def show
    render :show_new, :layout=> "account"
  end

  # 公司简介
  def company_info
  end
  # banner
  def banner_info
    banners = Banner.all
    respond_to do |format|
      format.json do
        render json: banners.to_json
      end
    end
  end

  def info_json
    loans = Loan.bidding_or_after.order('id desc').limit(6)
    loan_infos = {}
    loans.each_with_index do |loan, index|
      loan_infos.merge!((index.to_s).to_sym => {id: loan.id, amount: loan.amount, state: loan.state.name, title: loan.title, name: loan.borrower.name, progress: loan.progress, interest: loan.interest, month: loan.months})
    end

    articles = {}
    Article.select('id, title').notice.each_with_index do |article, index|
      articles.merge!(index.to_s.to_sym => {id: article.id, title: article.title})
    end

    info = {
            invest_people: User.lender.count,
            invest_amount: rmb_wan(Loan.total_amount),
            interest_amount: rmb_wan(Collection.sum(:interest)),
            loans: loan_infos,
            notices: articles
          }
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end

  def basic_info_json
    info = {company_name: SystemConfig.company_name.value,
            phone400: SystemConfig.phone400.value,
            serve_time: SystemConfig.serve_time.value,
            qq_server: SystemConfig.qq_server.value,
            qq_group: SystemConfig.qq_group.value,
            username: current_user.try(:username).to_s
          }
    respond_to do |format|
      format.json do
        render json: info.to_json
      end
    end
  end


end
