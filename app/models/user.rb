# coding: utf-8
class User < ActiveRecord::Base
  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :async, :confirmable, :authentication_keys => [:login]

  # attr_accessible :username, :email, :password, :password_confirmation, :remember_me, :role_ids, :auth_realname, :trade_password,:trade_password_confirmation, :confirmed_at, :auth_mobile, :login

  validates :username, :presence => true, :uniqueness => {:message=>"用户名已存在"}, :format => {:with=>/.{2,16}/i, :message=>"2-16个字符"}

  attr_accessor :login

  #has_and_belongs_to_many :roles, :join_table => 'users_roles'
  has_many :permissions, :through => :roles
  has_one :info, :class_name => "UserInfo"
  has_many :articles
  has_many :loans
  has_many :pay_orders
  has_one :user_cash
  has_many :withdraws
  has_many :user_banks
  has_many :repayments
  has_many :bids
  has_many :collections
  has_many :auto_invest_rules
  has_many :contacts
  has_many :received_messages, :class_name => "Message", :foreign_key => "receive_user_id"
  has_many :sent_messages, :class_name => "Message", :foreign_key => "send_user_id"
  belongs_to :from_user,:class_name=>"User",:foreign_key => "from_user_id"
  has_many :invite_users,:class_name=>"User",:foreign_key => "from_user_id"

  has_many :identifications
  accepts_nested_attributes_for :identifications

  default_scope { order("id asc") }
  scope :simple_search, lambda{|key_word| where("email like '%#{key_word}%' or username like '%#{key_word}%' or id in(select user_id from user_infos where name like '%#{key_word}%' or phone like '%#{key_word}%' or mobile like '%#{key_word}%')")  }
  scope :auth_mobile_pass, lambda{|status=nil| where(:auth_mobile => ((status.nil? || status==true) ? true : false))}
  scope :auth_realname_pass, -> {where(:auth_realname => 1)}
  scope :auth_realname_reject, -> {where(:auth_realname => 0)}
  scope :auth_realname_ready, -> {where(:auth_realname => 2)}
  scope :auth_realname_notready, -> {where(:auth_realname => nil)}
  scope :of_role, ->(role) { joins(:roles).where("roles.name = ?", role) }
  scope :lender, -> {joins(:roles).where("roles.name = ?", '投资人')}

  scope :auth_email_pass, -> {where('confirmed_at is not null')}

  UserCash::TYPES.values.each do |type|
    {'add' => '+', 'minus' => '-'}.each do |key, value|
      delegate "#{key}_#{type}", to: :user_cash
    end
  end

  UserCash::TYPES.values.each do |cash|
    delegate cash, to: :user_cash
  end

  after_create :create_user_cash, :create_user_info

  def create_user_cash
    UserCash.create({:user => self})
  end

  def create_user_info
    info = UserInfo.new({:user => self})
    info.save(:validate => false)
  end

  # 账户总额 = 可用金额 + 待收总额 + 提现冻结
  def total_amount
    self.available.to_f + self.not_collection_total.to_f + self.freeze_amount.to_f
  end

  def name
    if self.id > 0
      name = self.try(:info).try(:name).to_s
    else
      case self.id
      when User.company.id
        '公司账户'
      when User.agent.id
        '公司托管账户'
      when User.asset.id
        '投资人委托账户'
      when User.input_fee.id
        '汇入手续费'
      when User.output_fee.id
        '提现手续费'
      end
    end
  end

  def name_or_email
    if self.id > 0
      name = self.try(:info).try(:name).to_s
      if name.blank?
        self.email
      else
        name
      end
    else
      case self.id
      when User.company.id
        '公司账户'
      when User.agent.id
        '公司托管账户'
      when User.asset.id
        '投资人委托账户'
      when User.input_fee.id
        '汇入手续费'
      when User.output_fee.id
        '提现手续费'
      end
    end
  end

  def is_admin?
    roles.map(&:is_admin).include? true
  end

  def has_role? role
    self.roles.map(&:name).include? role
  end

  def self.company
    self.find_by_id(0)
  end

  # Risk fund account, to store risk fund
  def self.risk_fund
    self.find_by_id(-1)
  end

  # Agent account, to store money for bid, repayment, etc
  def self.agent
    self.find_by_id(-2)
  end

  def self.asset
    self.find_by_id(-3)
  end

  def self.input_fee
    self.find_by_id(-101)
  end

  def self.output_fee
    self.find_by_id(-102)
  end

  def cash_flows
    CashFlow.with_user(self.id)
  end

  def check_auth_realname
    if (info.id_card.present? && name.present? && info.idcard_pic_url.present?)
      self.update_attribute(:auth_realname, 2)
    else
      self.update_attribute(:auth_realname, nil)
    end
  end

  def auth_realname_state
    case auth_realname
    when nil
      "信息不全"
    when 0
      "已驳回"
    when 1
      "已认证"
    when 2
      "待审核"
    end
  end

  def auth_realname_pass pass
    self.auth_realname = pass
    if self.save
      {code: 1, data: "修改成功"}
    else
      {code: 0, data: "修改失败"}
    end
  end

  def pass_auth_mobile
    self.update_attribute(:auth_mobile, true)
  end

  # 提现密码
  def trade_password
    @trade_password ||= BCrypt::Password.new(encrypted_trade_password)
  end

  def trade_password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.encrypted_trade_password = @password
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.find_by_login(login)
    self.find_by_email(login) or self.find_by_username(login)
  end
end
