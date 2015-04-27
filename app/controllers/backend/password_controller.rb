# encoding: utf-8

class Backend::PasswordController < Backend::BaseController

	def index

	end

	def update
		if current_user.update_attributes(params[:user])
			flash[:success] = '密码修改成功'
		else
			flash[:errors] = current_user.errors
		end
		render :index
	end
end
