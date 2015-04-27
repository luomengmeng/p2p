# encoding: utf-8

class UserMailer < Devise::Mailer
  default :from => %q("p2p"<weigang992003@163.com>)
	helper :application
	include Devise::Controllers::UrlHelpers

	def reset_password_instructions(record, token, opts={})
		headers["template_path"] = "mailer/reset_password_instructions"
  	super
	end
end