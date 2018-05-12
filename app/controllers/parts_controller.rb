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
      render 'toppages/index'
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
      redirect_to '/'
    else
      flash.now[:danger] = 'パーツは更新されませんでした'
    end
  end
  
  def print
    @part = current_user.parts.find_by(id: params[:id])
    gv=Gviz.new
    
    def mapping(own, map)
      if own.relatings.exists?
        own.relatings.each do |child|
          #map.route(own.title+own.content => child.title+child.content)
          map.graph do
            #紐づけ
            route :"#{own.title}" => "#{child.title}"
            #内容を追加する
            node :"#{own.title}", shape:'Mrecord', label:"{#{own.title} | #{own.content}}"
            node :"#{child.title}", shape:'Mrecord', label:"{#{child.title} | #{child.content}}"
            
          end
          mapping(child,map)
        end
      else
        parent = own.relateds.first
        #map.route(parent.title+parent.content => own.title+own.content)
        map.graph do
            
            route :"#{parent.title}" => "#{own.title}"
            
            node :"#{parent.title}", shape:'Mrecord', label:"{#{parent.title} | #{parent.content}}"
            node :"#{own.title}", shape:'Mrecord', label:"{#{own.title} | #{own.content}}"
            
        end
      end
    end
    
    mapping(@part,gv)

    filename = 'test' + @part.id.to_s
    
    gv.save('public/' + filename, :png)
    
    img = Cloudinary::Uploader.upload('public/' + filename + '.png', :public_id => 'test_remote')
    @ver = img["version"]
    Rails.logger.info("バージョン#{@ver}")
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