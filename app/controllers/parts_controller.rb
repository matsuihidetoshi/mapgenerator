# encoding: UTF-8
class PartsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :print]
  require "fileutils"

  def new
    @parent = Part.find(params[:id])
    @part = Part.new
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

  def print

    flusher = S3Flusher.new
    flusher.flush

    @part = current_user.parts.find(params[:id])
    gv=Gviz.new


    def mapping(own, map)
      if own.relatings.exists?
        own.relatings.each do |child|
          map.graph do
            nodes fontname: 'IPA GOTHIC', charset: 'UTF-8'
            route own.id => child.id
            node :"#{own.id}", shape:'Mrecord', label:  "{#{own.id} | #{own.title} | #{own.content}}"
            node :"#{child.id}", shape:'Mrecord', label: "{#{own.id} | #{child.title} | #{child.content}}"
          end
          mapping(child,map)
        end
      else
        parent = own.relateds.first
        map.graph do
          nodes fontname: 'IPA GOTHIC', charset: 'UTF-8'
          route parent.id => own.id
          node :"#{parent.id}", shape:'Mrecord', label: "{#{parent.id} | #{parent.title} | #{parent.content}}"
          node :"#{own.id}", shape:'Mrecord', label: "{#{own.id} | #{own.title} | #{own.content}}"
        end
      end
    end

    mapping(@part,gv)

    time_stamp = Time.now.to_i.to_s

    file_name = 'map' + @part.id.to_s + time_stamp

    gv.save('tmp/files/' + file_name, :pdf)

    uploader = S3Uploader.new
    uploader.upload('maps', 'tmp/files', file_name + '.pdf')

    downloader = S3Downloader.new
    @img = downloader.download('maps', file_name + '.pdf')

    File.delete('tmp/files/' + file_name + '.pdf')
    File.delete('tmp/files/' + file_name + '.dot')

  end

  private

  def part_params
    params.require(:part).permit(:title, :content)
  end

end
