# encoding: utf-8

class Backend::AdminsController < Backend::BaseController
	def index
		@roles = Role.is_admin
		@title = '管理员列表'
	end

	def new
		@admin = User.new
		@roles = Role.is_admin
		@title = '添加管理员'
	end

	def create
    @admin = User.new(admins_params)
    @roles = Role.is_admin
    if @admin.save
      flash[:success] = '添加成功'
      redirect_to backend_admins_path
    else
      flash[:errors] = @admin.errors
      render :new
    end
	end

	def edit
		@admin = User.find(params[:id])
		@roles = Role.is_admin
	end

	def update
		@admin = User.find(params[:id])
		@roles = Role.is_admin
  	if @admin.update_attributes(admins_params)
			flash[:success] = '修改成功'
			redirect_to :action => :index
		else
			flash[:errors] = @admin.errors
			render :edit
		end
	end

	def destroy
    @admin = User.find(params[:id])
    @admin.destroy

    respond_to do |format|
    	flash[:success] = '删除成功'
      format.html { redirect_to(backend_admins_path) }
      format.xml  { head :ok }
    end
	end
	private
	  def admins_params
	  	params.require(:user).permit(:confirmed_at,:username,:email,:password,:role,:password_confirmation, :role_ids => [])
	  end
end
