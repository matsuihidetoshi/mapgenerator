require 'rails_helper'

RSpec.describe S3Downloader, type: :model do
  it 'return url if downloaded successfully' do
    uploader = S3Downloader.new
    expect(uploader.download('maps', 'test.bin').include?('test.bin')).to eq true
  end
  it 'return false if download failed' do
    uploader = S3Downloader.new
    expect(uploader.download('maps', 'does_not_exist.bin')).to eq false
  end
end
