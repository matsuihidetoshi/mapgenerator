require 'aws-sdk-s3'
class S3Flusher < ApplicationService
  def initialize
    s3 = Aws::S3::Resource.new(region: ENV['S3_REGION'])
    @bucket = s3.bucket('mapgenerator')
  end

  def flush
    return @bucket.objects.select{|o| o.key.include?('.pdf') || o.key.include?('.png')}.each do |o|
      o.delete
    end
  end
end
