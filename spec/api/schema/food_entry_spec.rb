describe API::Schema::FoodEntry::Creation do
  let(:valid_input) do
    {
      date:       DateTime.parse('2016-08-21'),
      meal_name:  'dummy name',
      quantity:   1.25,
      serialized: 'x' * 50,
      portion_id: 1,
      user_id:    1
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
    let(:date_keys) { %i[date] }
    let(:str_keys)  { %i[meal_name serialized] }
    let(:flt_keys)  { %i[quantity] }
    let(:int_keys)  { %i[user_id portion_id] }
    let(:required)  { date_keys + str_keys + flt_keys + int_keys }

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
      (date_keys + str_keys).each do |key|
        input = valid_input.merge(key => 123)
        expect(described_class.call(input).success?).to be(false)
      end

      flt_keys.each do |key|
        input = valid_input.merge(key => 'asdfasdf')
        expect(described_class.call(input).success?).to be(false)
      end

      int_keys.each do |key|
        input = valid_input.merge(key => 'asdfasdf')
        expect(described_class.call(input).success?).to be(false)
      end
    end

    it 'enforces date format' do
      input = valid_input.merge(date: 'incorrect date format')
      expect(described_class.call(input).success?).to be(false)
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
