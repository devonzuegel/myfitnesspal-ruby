require 'bundler/setup'
require 'rspec'

require 'binary/sync_request'
require 'binary/type'

RSpec.describe Binary::Type do


  describe '#supported_types' do
    it 'should support the expected types' do
      expect(Binary::Type.supported_types).to eq(
        Binary::Type::SYNC_REQUEST => Binary::SyncRequest
      )
    end

    it 'supports all types'
  end
end