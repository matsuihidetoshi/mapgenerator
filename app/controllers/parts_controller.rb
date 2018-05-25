# encoding: UTF-8
class PartsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy, :edit, :print]
  require "fileutils"
  
  #パーツ作成アクション
  def create
    @relatepart = @@prepart
    @part = current_user.parts.build(part_params)
    if @part.save
      flash[:success] = 'パーツを作成しました'
      @relatepart.relate(@part)
      @relatepart.save
      redirect_to root_url
    else
      @parts = current_user.parts.order('created_at DESC').page(params[:page])
      flash .now[:danger] = 'パーツの作成に失敗しました'
      render :new
    end
  end
  
  #パーツ編集ページ
  def edit
    @part = current_user.parts.find_by(id: params[:id])
    @@prepart = @part
  end
  
  #パーツ編集アクション
  def update
    @part = current_user.parts.find_by(id: params[:id])
    
    if @part.update(part_params)
      flash[:success] = 'パーツは正常に更新されました'
      redirect_to root_path
    else
      flash.now[:danger] = 'パーツは更新されませんでした'
      render :edit
    end
  end
  
  def print
    @part = current_user.parts.find_by(id: params[:id])
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

    filename = 'test' + @part.id.to_s
    
    gv.save('public/' + filename, :png)
    
    img = Cloudinary::Uploader.upload('public/' + filename + '.png', :public_id => 'test_remote')
    @ver = img["version"]
    
    File.delete('public/' + filename + '.png')
    File.delete('public/' + filename + '.dot')
    
  end

  #パーツ新規作成ページ
  def new
    @part = Part.new
    @relatepart = @@prepart
  end

  #パーツ削除
  def destroy
    @part.destroy
    flash[:success] = 'パーツを削除しました'
    redirect_back(fallback_location: root_path)
  end
  
  private

  def part_params
    params.require(:part).permit(:title, :content)
  end
  
  def correct_user
    @part = current_user.parts.find_by(id: params[:id])
    unless @part
      redirect_to root_url
    end
  end
  
end