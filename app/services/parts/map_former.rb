class MapFormer < ApplicationService
  require 'fileutils'
  attr_accessor :path
  def form(part)
    S3Flusher.new.flush

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

    mapping(part,gv)

    time_stamp = Time.now.to_i.to_s

    file_name = 'map' + part.id.to_s + time_stamp

    gv.save('tmp/files/' + file_name, :pdf)

    S3Uploader.new.upload('maps', 'tmp/files', file_name + '.pdf')

    self.path = S3Downloader.new.download('maps', file_name + '.pdf')

    File.delete('tmp/files/' + file_name + '.pdf')
    File.delete('tmp/files/' + file_name + '.dot')
  end
end