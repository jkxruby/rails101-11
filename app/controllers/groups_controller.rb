class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy, :update, :show, :quit, :join]
  before_action :find_group_and_check_permission, only: [:update, :edit, :destroy]
def index
  @groups = Group.all
end

def new
  @group = Group.new
end

def create
  @group = Group.new(group_params)
  @group.user = current_user
  if @group.save
    redirect_to groups_path
  else
    render :new
  end
end

def edit
  @group.user = current_user
end

def update
  if @group.update(group_params)
    redirect_to groups_path, notice: "update success"
  else
    render :edit
  end
end

def show
  @group = Group.find(params[:id])
  @posts = @group.posts.order("created_at DESC").paginate(:page => params[:page], :per_page => 5)

end

def destroy
  @group.destroy
  redirect_to groups_path, alert: "deleted"
end

  def join
    @group = Group.find(params[:id])
    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本版讨论成功"
    else
      flash[:warning] = "你已经是成员了"
    end
    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] ="已经退出"
    else
      flash[:alert] ="本来就不是，退毛线"
    end
    redirect_to group_path(@group)
  end
  
private
  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "you have no permission"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end

end
