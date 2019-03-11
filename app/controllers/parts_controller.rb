class PartsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :print]
  require "fileutils"

  def new
    @parent = Part.find(params[:id])
    @part = Part.new
    if params[:edit].present?
      @edit = true
    end
  end

  def create
    @parent = Part.find(params[:part][:parent_id])
    @part = current_user.parts.build(part_params)
    if @part.save
      flash[:success] = 'Created a part'
      @parent.relate(@part)
      @parent.save
      redirect_to root_url
    else
      @parts = current_user.parts.order('created_at DESC').page(params[:page])
      flash .now[:danger] = 'Failed to create a part'
      render :new
    end
  end

  def edit
    @part = current_user.parts.find(params[:id])
  end

  def update
    @part = current_user.parts.find(params[:id])

    if @part.update(part_params)
      flash[:success] = 'Updated the part'
      redirect_to root_path
    else
      flash.now[:danger] = 'Failed to update the part'
      render :edit
    end
  end

  def destroy
    @part = Part.find(params[:id])
    @part.destroy
    flash[:success] = 'Removed the part'
    redirect_back(fallback_location: root_path)
  end

  private

  def part_params
    params.require(:part).permit(:title, :content)
  end

end
