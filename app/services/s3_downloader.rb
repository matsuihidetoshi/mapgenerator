require 'aws-sdk-s3'
class S3Downloader < ApplicationService
  def initialize
    @s3 = Aws::S3::Resource.new(region: ENV['S3_REGION'])
    @bucket_name = 'mapgenerator'
  end

  def send(s3_path,file_path,file_name)
    begin
      o = @s3.bucket(@bucket_name).object(s3_path + '/' + file_name)
      o.get(response_target: file_path + '/' + file_name)
    rescue => e
      Rails.logger.info(e)
      return false
    end
  end

end
