require 'aws-sdk-s3'
class S3Downloader < ApplicationService
  def initialize
    s3 = Aws::S3::Resource.new(region: ENV['S3_REGION'])
    @bucket = s3.bucket('mapgenerator')
  end

  def download(s3_path,file_name)
    begin
      return @bucket.objects.find{|o| o.key == s3_path + '/' + file_name}.presigned_url(:get)
    rescue => e
      Rails.logger.info(e)
      return false
    end
  end

end
