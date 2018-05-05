class PartsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def create
    @part = current_user.parts.build(part_params)
    if @part.save
      flash[:success] = 'パーツを作成しました'
      redirect_to root_url
    else
      @parts = current_user.parts.order('created_at DESC').page(params[:page])
      flash .now[:danger] = 'パーツの作成に失敗しました'
      render 'toppages/index'
    end
  end

  def destroy
    @part.destroy
    flash[:success] = 'パーツを削除しました'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def part_params
    params.require(:part).permit(:content)
  end
  
  def correct_user
    @part = current_user.parts.find_by(id: params[:id])
    unless @part
      redirect_to root_url
    end
  end
  
end