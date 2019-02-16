require 'rails_helper'

RSpec.describe S3Uploader, type: :model do
  it 'return true if uploaded successfully' do
    uploader = S3Uploader.new
    expect(uploader.send('maps','spec/models/mock_ups', 'test.bin')).to eq true
  end
end
