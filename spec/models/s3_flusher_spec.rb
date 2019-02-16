require 'rails_helper'

RSpec.describe S3Flusher, type: :model do
  it 'return array when flush' do
    flusher = S3Flusher.new
    expect(flusher.flush.class).to eq Array
  end
end
