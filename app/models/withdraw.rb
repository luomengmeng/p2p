# coding: utf-8
class Withdraw < ActiveRecord::Base
  # attr_accessible :user, :amount, :audit_comment, :audit_time, :auditor_id, :bank, :branch, :card_number, :fee, :pay_class, :received_amount, :status, :user_id, :province, :city, :area, :notice
  belongs_to :user
  belongs_to :auditor, :class_name => "User", :foreign_key => 'auditor_id'
  STATUS = { '审核中' => 'auditing', '成功' => 'pass', '失败' => 'fail' }
  scope :succeed, -> {where(:status => 'pass')}

  def self.create_by_user user, amount, bank
    self.create(:user => user,
                :amount => amount,
                :card_number => bank.card_number,
                :bank => bank.bank,
                :branch => bank.branch,
                :province => bank.province,
                :city => bank.city,
                :area => bank.area)
  end
  # 出借人提现 （代付或转账）
  # @param [String] 支付平台
  def pay_lender pay_class, current_user
    Withdraw.transaction do
      if self.status == 'auditing'
        self.update_attributes( :status => 'pass',
                                :pay_class => pay_class,
                                :received_amount => self.amount,
                                :fee => 0,
                                :auditor_id => current_user.id,
                                :audit_time => Time.now)

        # 生成提现 cash_flow
        CashFlow.pay_lender_for_withdraw(self)
        self.send_messages(true,self.notice)
      end
    end
  end

  def return_to_lender current_user
    Withdraw.transaction do
      if self.status == 'auditing'
        self.update_attributes( :status => 'fail',
                                :received_amount => 0,
                                :fee => 0,
                                :auditor_id => current_user.id,
                                :audit_time => Time.now)

        CashFlow.withdraw_return_to_lender(self)
        self.send_messages(false,self.notice)
      end
    end
  end

  #status  提现是否成功
  #res     站内信补充信息
  def send_messages(status, res='')
    content=''
    res= res || ""
    case status
    when true
      title = "提现申请成功"
      content = "您于#{self.created_at.to_s(:long)}申请提现#{self.amount.round(2)}元已通过审核，"+ (res.present? ? res : "请您关注您的银行卡账户信息。")
    when false
      title = "提现申请失败"
      content = "您于#{self.created_at.to_s(:long)}申请提现#{self.amount.round(2)}元未通过审核，"+ (res.present? ? res : "请仔细检查银行卡信息。")
    end
    WithdrawMessage.create(receive_user_id: self.user_id, title: title, content: content, status: Dict::MessageStatus.unread.id)
  end

end
