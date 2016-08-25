describe API::Schema::Result do
  let(:no_messages)    { {} }
  let(:messages)       { { param1: 'is missing' } }
  let(:partial_output) { { param1: 'xxx' } }
  let(:result)         { described_class.new(messages, partial_output) }
  let(:successful_res) { described_class.new(no_messages, partial_output) }

  describe '#success?' do
    it 'is false when messages are not empty' do
      expect(result.success?).to be false
    end

    it 'is true when messages are empty' do
      expect(successful_res.success?).to be true
    end
  end

  describe '#messages' do
    it 'returns the expected messages' do
      expect(result.messages).to eql messages
    end

    it 'returns the expected messages' do
      expect(successful_res.messages).to eql({})
    end
  end

  describe '#output' do
    it 'is equivalent to output when successful' do
      expect(successful_res.output).to eql partial_output
    end

    it 'returns blank output when unsuccessful' do
      expect(result.output).to eql({})
    end
  end
end
