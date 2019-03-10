class MapFormersController < ApplicationController
  before_action :correct_user
  def show
    @part = Part.find(params[:id])
    @former = MapFormer.new
    @former.form(@part)
  end
end
