class GroupsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy, :update, :show]
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
  @posts = @group.posts.order("created_at DESC")
end

def destroy
  @group.destroy
  redirect_to groups_path, alert: "deleted"
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
