# coding: utf-8
class AutoInvestRule < ActiveRecord::Base
#  attr_accessible :actived_at, :amount, :credit_level, :max_interest, :max_months, :min_interest, :min_months, :remain_amount, :repay_style, :user_id, :with_guarantee, :with_mortgage

  belongs_to :user

  scope :active, -> {where('actived_at is not null')}
  scope :match_loan, lambda {|loan| where(["amount < ? and min_interest <= ? and max_interest >= ? and min_months <= ? and max_months >= ? and (with_mortgage = ? or with_mortgage = 'false' or with_mortgage is null) and (with_guarantee = ? or with_guarantee = 'false' or with_guarantee is null) and (repay_style = ? or repay_style = '' or repay_style is null)",
                                        loan.available_amount, loan.interest, loan.interest, loan.months, loan.months, loan.with_mortgage, loan.with_guarantee, loan.repay_style]) }
  scope :actived_at_gt, -> {where(["actived_at > ?", SystemConfig.auto_invest_at])}
  scope :actived_at_lte, -> {where(["actived_at <= ?", SystemConfig.auto_invest_at])}

  LIMIT = 0.2 # 最多投标的百分之二十

  # 自动投标
  # TODO 逻辑需要修改
  def self.exec_for loan
    if loan.available_amount.to_f > 0
      loan.update_attribute(:auto_invested_at, Time.now)
      self.includes(:user).active.actived_at_gt.match_loan(loan).each do |rule|
        if rule.user.available.to_f > (rule.amount.to_f + rule.remain_amount.to_f)
          begin
            Bid.auto_invest_by_user rule.user, loan.id, [rule.amount, loan.amount * LIMIT].min
          rescue
          end
        end
        SystemConfig.find_by_key('auto_invest_at').update_attribute(:value, rule.actived_at)
        if loan.available_amount.to_f == 0
          exit
        end
      end
    end

    if loan.available_amount.to_f > 0
      self.includes(:user).active.actived_at_lte.match_loan(loan).each do |rule|
        if rule.user.available.to_f > (rule.amount.to_f + rule.remain_amount.to_f)
          begin
            Bid.auto_invest_by_user rule.user, loan.id, [rule.amount, loan.amount * LIMIT].min
          rescue
          end
        end
        SystemConfig.find_by_key('auto_invest_at').update_attribute(:value, rule.actived_at)
        if loan.available_amount.to_f == 0
          exit
        end
      end
    end

  end

end
