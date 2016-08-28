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

  describe '#<<' do
    it 'merging identical successes has no effect' do
      combined = successful_res << successful_res
      expect(combined).to eql(successful_res)
    end

    it 'merging a success with a different success results in output from the first' do
      combined = successful_res << described_class.new(no_messages, param2: 'blah')
      expect(combined).to eql(successful_res)
    end

    it 'adding success to failure results in that same failure' do
      combined = result << successful_res
      expect(combined).to eql(result)
    end

    it 'adding failure to success results in messages from failure and output from success' do
      combined = described_class.new(no_messages, param2: 'blah') << result
      expect(combined).to eql(described_class.new(result.messages, param2: 'blah'))
    end

    it 'adding 2 failures results in a failure of combined messages' do
      failure1      = described_class.new({ a: 'blah' }, 'output1')
      failure2      = described_class.new({ b: 'moon' }, 'output2')
      expected_msgs = failure1.messages.merge(failure2.messages)

      expect(failure1 << failure2).to eql(described_class.new(expected_msgs, 'output1'))
    end
  end
end
