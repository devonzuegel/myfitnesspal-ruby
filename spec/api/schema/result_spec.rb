describe API::Schema::Result do
  let(:messages) { { param1: 'is missing' } }
  let(:result)   { described_class.new(messages) }

  describe '#success?' do
    it 'is false when messages are not empty' do
      expect(result.success?).to eql false
    end

    it 'is true when messages are empty' do
      expect(described_class.new({}).success?).to eql true
    end
  end

  describe '#messages' do
    it 'returns the expected messages' do
      expect(result.messages).to eql messages
    end
  end
end
