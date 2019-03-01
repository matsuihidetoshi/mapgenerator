class ToppagesController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @part = current_user.parts.build
      @parts = current_user.parts.order('created_at ASC').page(params[:page])
    end
  end
end
