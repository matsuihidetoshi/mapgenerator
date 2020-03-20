module Api
  module V1
    class PartsController < ApplicationController
      skip_before_action :verify_authenticity_token

      def index
        parts = Part.order(created_at: :desc)
        render json: { status: 'SUCCESS', message: 'loaded parts', data: parts }
      end

      def show
        part = Part.find(params[:id])
        render json: { status: 'SUCCESS', message: 'loaded the part', data: part }
      end

      def create
        part = Part.new(part_params)
        if part.save
          render json: { status: 'SUCCESS', message: 'loaded the part', data: part }
        else
          render json: { status: 'ERROR', message: 'part not saved', data: part.errors }
        end
      end

      def destroy
        part = Part.find(params[:id])
        part.destroy
        render json: { status: 'SUCCESS', message: 'deleted the part', data: part }
      end

      def update
        part = Part.find(params[:id])
        if part.update(part_params)
          render json: { status: 'SUCCESS', message: 'updated the part', data: part }
        else
          render json: { status: 'SUCCESS', message: 'loaded the part', data: part }
        end
      end

      private

      def part_params
        params.require(:part).permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end