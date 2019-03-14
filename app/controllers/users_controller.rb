class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :destroy]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @part = @user.parts.build(title: 'default', content: 'none')
      if @part.save
        flash[:success] = 'Created the first part'
      else
        flash .now[:danger] = 'Failed to create the first part'
      end
      flash[:success] = 'Signed Up'
      session[:user_id] = @user.id
      redirect_to root_path
    else
      flash.now[:danger] = 'SignUp Failed'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Updated user data'
      redirect_to @user
    else
      flash.now[:danger] = 'Update Failed'
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = 'Deleted User'
    redirect_to root_path
  end
end

private

def user_params
  params.require(:user).permit(:name, :email, :password, :password_confirmation)
end
