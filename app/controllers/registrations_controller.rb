# encoding: utf-8

class RegistrationsController < Devise::RegistrationsController
	before_action :configure_permitted_parameters
	layout 'devise'
	def new
		super
	end

	def create
		super do |resource|
			resource.roles << Role.find_by_name('投资人')
			resource.from_user_id = cookies[:from_user]
			resource.save
			return render :action => :confirmable
		end
	end

	def confirmable

	end

	private

	def configure_permitted_parameters
	  devise_parameter_sanitizer.for(:sign_up) { |u| u.permit( :email, :username, :password, :password_confirmation) }
	end
end