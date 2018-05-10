class ToppagesController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @part = current_user.parts.build
      @parts = current_user.parts.order('created_at DESC').page(params[:page])
    end

    # Graph do
    #   route :main => [:init, :parse, :cleanup, :printf]
    #   route :init => :make, :parse => :execute
    #   route :execute => [:make, :compare, :printf]

    #   save(:sample1, :png)
    # end

  end
end