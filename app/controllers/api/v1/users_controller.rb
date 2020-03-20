module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        users = User.order(created_at: :desc)
        render json: { status: 'SUCCESS', message: 'loaded users', data: users }
      end

      def show
        user = User.find(params[:id])
        render json: { status: 'SUCCESS', message: 'loaded the user', data: user }
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: { status: 'SUCCESS', message: 'loaded the user', data: user }
        else
          render json: { status: 'ERROR', message: 'user not saved', data: user.errors }
        end
      end

      def destroy
        user = User.find(params[:id])
        user.destroy
        render json: { status: 'SUCCESS', message: 'deleted the user', data: user }
      end

      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: { status: 'SUCCESS', message: 'updated the user', data: user }
        else
          render json: { status: 'SUCCESS', message: 'loaded the user', data: user }
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end