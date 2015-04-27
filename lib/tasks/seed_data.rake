# coding: utf-8
namespace :seed_data do

	desc 'seed data'

	# 执行所有tasks，网站初次部署时可用
	task :all => [:set_default_propagandas, :set_default_articles, :set_loan_state, :add_cash_flow_type,
								:set_default_roles, :set_default_admin,:setup_default_permissions,
								:set_marriage_type, :set_education_type, :set_degree_type, :set_gender_type, :set_message_status, :add_system_config_variable,
								:add_company_account]

	# 添加默认权限
	task :setup_default_permissions => :environment do
		Permission.setup_actions_controllers_db
	end

	# 默认角色
	task :set_default_roles => :environment do
		Role.create([
			{:name => '投资人'},
			{:name => '贷款人'}])

		Role.create([
			{:name => '超级管理员'},
			{:name => '初级审核'},
			{:name => '高级审核'},
			{:name => '财务'},
			{:name => '客服经理'},
			{:name => '客服'}
			]).each do |role|
				role.is_admin = true
				role.save
			end
	end

	# 默认超级管理员
	task :set_default_admin => :environment do
		user = User.create(:username => 'super_admin', :email => 'super_admin@admin.com', :password => 'test1234',:confirmed_at => Time.now)
		user.roles << Role.find_by_name('超级管理员')
	end

	task :add_company_account=>:environment do
	  ActiveRecord::Base.connection.execute("insert into users (id,email,created_at,updated_at) values(0,'company', now(), now())") if User.where(:id => 0).blank?
	  ActiveRecord::Base.connection.execute("insert into users (id,email,created_at,updated_at) values(-1,'risk_fund', now(), now())") if User.where(:id => -1).blank?
	  ActiveRecord::Base.connection.execute("insert into users (id,email,created_at,updated_at) values(-2,'agent', now(), now())") if User.where(:id => -2).blank?
	  ActiveRecord::Base.connection.execute("insert into users (id,email,created_at,updated_at) values(-3,'asset', now(), now())") if User.where(:id => -3).blank?
	  ActiveRecord::Base.connection.execute("insert into users (id,email,created_at,updated_at) values(-101,'input_fee', now(), now())") if User.where(:id => -101).blank?
	  ActiveRecord::Base.connection.execute("insert into users (id,email,created_at,updated_at) values(-102,'output_fee', now(), now())") if User.where(:id => -102).blank?

	  ActiveRecord::Base.connection.execute("insert into user_cashes (user_id,created_at,updated_at) values(0, now(), now())") if UserCash.where(:user_id => 0).blank?
	  ActiveRecord::Base.connection.execute("insert into user_cashes (user_id,created_at,updated_at) values(-1, now(), now())") if UserCash.where(:user_id => -1).blank?
	  ActiveRecord::Base.connection.execute("insert into user_cashes (user_id,created_at,updated_at) values(-2, now(), now())") if UserCash.where(:user_id => -2).blank?
	  ActiveRecord::Base.connection.execute("insert into user_cashes (user_id,created_at,updated_at) values(-3, now(), now())") if UserCash.where(:user_id => -3).blank?
	  ActiveRecord::Base.connection.execute("insert into user_cashes (user_id,created_at,updated_at) values(-101, now(), now())") if UserCash.where(:user_id => -101).blank?
	  ActiveRecord::Base.connection.execute("insert into user_cashes (user_id,created_at,updated_at) values(-102, now(), now())") if UserCash.where(:user_id => -102).blank?
	end

	# 婚姻状况
	# 10-未婚；
	# 20-已婚；
	# 21-初婚；
	# 22-再婚；
	# 23-复婚；
	# 30-丧偶；
	# 40-离婚；
	# 90-未说明的婚姻状况。
	task :set_marriage_type => :environment do
    { unmarried: 10, married: 20, first_married: 21, sec_married: 22, remarried: 23, widowed: 30, divorce: 40, unknown: 90}.each do |v|
    	Dict::MarriageType.create(name: v[0], code: v[1]) if Dict::MarriageType.find_by_name(v[0]).nil?
    end
	end
	#最高学历
	# 10-研究生；
	# 20-大学本科（简称“大学”）；
	# 30-大学专科和专科学校（简称“大专”）；
	# 40-中等专业学校或中等技术学校；
	# 50-技术学校；
	# 60-高中；
	# 70-初中；
	# 80-小学；
	# 90-文盲或半文盲；
	# 99-未知。
	task :set_education_type => :environment do
		{graduate: 10, university: 20, college: 30, secondary_school: 40, technical_school: 50, high_school: 60, middle_school: 70, primary_school: 80, illiteracy: 90, unknown: 99}.each do |v|
			Dict::EducationType.create(name: v[0], code: v[1]) if Dict::EducationType.find_by_name(v[0]).nil?
		end
	end
	#最高学位
	# 	0-其他；
	# 1-名誉博士；
	# 2-博士；
	# 3-硕士；
	# 4-学士；
	# 9-未知。
	task :set_degree_type => :environment do
		{other: 0, honorary_doctor: 1, doctor: 2, master: 3, bachelor: 4, unknown: 99}.each do |v|
			Dict::DegreeType.create(name: v[0], code: v[1]) if Dict::DegreeType.find_by_name(v[0]).nil?
		end
	end
	#职位

	#性别
	task :set_gender_type => :environment do
		{male: 1, female: 2, unknown: 0}.each do |v|
			Dict::GenderType.create(name: v[0], code: v[1]) if Dict::GenderType.find_by_name(v[0]).nil?
		end
	end

	#站内消息状态
	desc "message status"
	task :set_message_status => :environment do
		{read: 1, unread: 0}.each do |v|
			Dict::MessageStatus.create(name: v[0], code: v[1]) if Dict::MessageStatus.find_by_name(v[0]).nil?
		end
	end

	# 宣传管理 默认栏目
	task :set_default_propagandas => :environment do
		# ['网站公告', '媒体报道', '帮助中心', '关于我们', '监管报告'].each do |p|
		['网站公告', '媒体报道'].each do |p|
			Propaganda.create(name: p) if Propaganda.find_by_name(p).nil?
		end
	end

	# 关于我们 默认子栏目
	# task :set_default_articles => :environment do
	# 	['公司简介', '合作伙伴', '招贤纳士', '联系我们'].each do |p|
	# 		Article.create(title: p, propaganda_id: Propaganda.about_us.current.try(:id), content: "#{p}--请编辑内容") if Article.find_by_title(p).nil?
	# 	end
	# end

	task :add_cash_flow_type=>:environment do

	  %w{charge pay_bid auto_pay_bid repay withdraw withdraw_return withdraw_apply return_pay_bid transfer_to_borrower offline_recharge sell_bid sell_bid_fee promote_prize prize_first prize_max prize_last prize_register}.each do |v|

	    Dict::CashFlowDescription.create(:name => v) if Dict::CashFlowDescription.find_by_name(v).nil?
	  end
	end

	task :set_loan_state=>:environment do
		%w{junior_auditing senior_auditing wait_to_bid bidding failed bids_auditing repaying overdue finished }.each do |v|
			Dict::LoanState.create(:name => v) if Dict::LoanState.find_by_name(v).nil?
		end
	end

	task :add_system_config_variable=>:environment do
		# can be edit
		%w{company_name email_name email_pass sms_name sms_pass title keywords description}.each do |key|
			SystemConfig.create(:key => key) if SystemConfig.send(key).nil?
		end

		SystemConfig.create(:key => 'mongodb_logger_pass', :value => 'test1234') if SystemConfig.mongodb_logger_pass.nil?

		# can not be edit!!!!
		%w{auto_invest_at}.each do |key|
			SystemConfig.create(:key => key, :editable => false) if SystemConfig.send(key).nil?
		end
		SystemConfig.find_by_key('auto_invest_at').update_attribute(:value, DateTime.now) if SystemConfig.find_by_key('auto_invest_at').value.blank?

		# 债权转让手续费
		%w{sell_bid_fee}.each do |key|
			SystemConfig.create(:key => key) if SystemConfig.send(key).nil?
		end
		SystemConfig.find_by_key('sell_bid_fee').update_attribute(:value, 0.01) if SystemConfig.find_by_key('sell_bid_fee').value.blank?

		# 推荐奖励设置
		%w{promotion_status promotion_type promotion_threshold promotion_amount promotion_ratio}.each do |key|
			SystemConfig.create(:key => key, :editable => true) if SystemConfig.send(key).nil?
		end
		SystemConfig.find_by_key('promotion_status').update_attribute(:value, 'off') if SystemConfig.find_by_key('promotion_status').value.blank?
		SystemConfig.find_by_key('promotion_threshold').update_attribute(:value, '10000') if SystemConfig.find_by_key('promotion_threshold').value.blank?

		# 首投奖
		%w{prize_first_status prize_first_threshold prize_first_amount}.each do |key|
			SystemConfig.create(:key => key, :editable => true) if SystemConfig.send(key).nil?
		end
		SystemConfig.find_by_key('prize_first_status').update_attribute(:value, 'off') if SystemConfig.find_by_key('prize_first_status').value.blank?
		SystemConfig.find_by_key('prize_first_threshold').update_attribute(:value, '10000') if SystemConfig.find_by_key('prize_first_threshold').value.blank?

		# 单标冠军奖
		%w{prize_max_status prize_max_amount}.each do |key|
			SystemConfig.create(:key => key, :editable => true) if SystemConfig.send(key).nil?
		end
		SystemConfig.find_by_key('prize_max_status').update_attribute(:value, 'off') if SystemConfig.find_by_key('prize_max_status').value.blank?

		# 满标奖
		%w{prize_last_status prize_last_amount}.each do |key|
			SystemConfig.create(:key => key, :editable => true) if SystemConfig.send(key).nil?
		end
		SystemConfig.find_by_key('prize_last_status').update_attribute(:value, 'off') if SystemConfig.find_by_key('prize_last_status').value.blank?

		# 注册奖励
		%w{prize_register_status prize_register_amount}.each do |key|
			SystemConfig.create(:key => key, :editable => true) if SystemConfig.send(key).nil?
		end
		SystemConfig.find_by_key('prize_register_status').update_attribute(:value, 'off') if SystemConfig.find_by_key('prize_register_status').value.blank?

		%w{phone400 serve_time qq_server qq_group}.each do |key|
			SystemConfig.create(:key => key, :editable => true) if SystemConfig.send(key).nil?
		end
		
	end

	# 正式环境不需要运行
	task :update_users => :environment do
		User.update_all("confirmed_at='#{Time.now.to_formatted_s(:db)}'")
	end
end