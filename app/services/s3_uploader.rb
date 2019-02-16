class S3Uploader < ApplicationService
  def self.call(text)
    puts text
    return text + ' is done.'
  end
end
