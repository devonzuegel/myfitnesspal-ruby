describe API::Schema::FoodPortion::Creation do
  let(:valid_input) do
    {
      options_index: 1,
      description:   'dummy description',
      amount:        1.0,
      gram_weight:   1.0,
      serialized:    'x' * 50,
      food_id:       1
    }
  end

  context 'valid input' do
    let(:result) { described_class.call(valid_input) }

    it 'is successful' do
      expect(result.success?).to be(true)
    end

    it 'has no messages' do
      expect(result.messages).to eql({})
    end

    it 'has the expected output' do
      expect(result.output).to eql(valid_input)
    end
  end

  context 'invalid valid_input' do
    let(:str_keys) { %i[description serialized] }
    let(:flt_keys) { %i[amount gram_weight] }
    let(:int_keys) { %i[food_id options_index] }
    let(:required) { str_keys + flt_keys + int_keys }

    def without(_hash, key_to_remove)
      valid_input.reject { |k, _v| k == key_to_remove }
    end

    it 'requires all keys' do
      required.each do |key|
        input = without(valid_input, key)
        expect(described_class.call(input).success?).to be(false)
        expect(described_class.call(input).output).to eql({})
      end
    end

    it 'enforces minimum length of 50 for :serialized' do
      input = without(valid_input, :serialized)
      expect(described_class.call(input).messages)
        .to eql(serialized: ['is missing', 'size cannot be less than 50'])
    end

    it 'requires keys to be of expected types' do
      str_keys.each do |key|
        input = valid_input.merge(key => 123)
        expect(described_class.call(input).success?).to be(false)
      end

      flt_keys.each do |key|
        input = valid_input.merge(key => 'asdfasdf')
        expect(described_class.call(input).success?).to be(false)
      end

      int_keys.each do |key|
        input = valid_input.merge(key => 'xxx')
        expect(described_class.call(input).success?).to be(false)
      end
    end

    it 'enforces minimum length of 50 for :serialized' do
      input = valid_input.merge(serialized: 'abcd')
      expect(described_class.call(input).success?).to be(false)
    end

    it 'enforces minimum length of 50 AND str? for :serialized' do
      input = valid_input.merge(serialized: 123)
      expect(described_class.call(input).messages)
        .to eql(serialized: ['must be a string', 'size cannot be less than 50'])
    end
  end
end
