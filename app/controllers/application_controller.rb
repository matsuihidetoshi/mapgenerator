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

end
