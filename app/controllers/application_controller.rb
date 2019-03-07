class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require "gviz"
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    @count_parts = user.parts.count
  end

  def correct_user
    @part = current_user.parts.find(params[:id])
    unless @part
      redirect_to root_url
    end
  end

end
