require 'aws-sdk-s3'
class S3Uploader < ApplicationService
  def initialize
    @bucket_name = 'mapgenerator'

    Aws.config.update({
        region: 'ap-northeast-1',
        credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY'], ENV['AWS_SECRET_KEY'])
    })

    s3 = Aws::S3::Resource.new
    @bucket = s3.bucket(@bucket_name)
  end

  def send(s3_path,file_path,file_name)
    o = @bucket.object(s3_path + '/' + file_name)
    o.upload_file(file_path + '/' + file_name)
  end

end
