describe API::Schema::LastSyncInfo::Creation do
  let(:valid_input) do
    {
      deleted_item:   '2561719350',
      diary_note:     '2016-10-30 21:02:18 UTC',
      exercise:       '1018692',
      exercise_entry: '2293971121',
      food:           '318556366',
      food_entry:     '5776792680',
      measurement:    '2016-10-30 21:01:43 UTC',
      user_property:  '2016-07-03 22:20:44 UTC',
      user_status:    '',
      water_entry:    '2014-12-25 01:20:59 UTC',
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
    let(:required_str_keys) do
      %i[
        deleted_item
        diary_note
        exercise
        exercise_entry
        food
        food_entry
        measurement
        user_property
        user_status
        water_entry
      ]
    end

    def without(_hash, key_to_remove)
      valid_input.reject { |k, _v| k == key_to_remove }
    end

    it 'requires all keys' do
      required_str_keys.each do |key|
        input = without(valid_input, key)
        expect(described_class.call(input).success?).to be(false)
        expect(described_class.call(input).output).to eql({})
      end
    end

    it 'requires keys to be of expected types' do
      required_str_keys.each do |key|
        input = valid_input.merge(key => 123)
        expect(described_class.call(input).success?).to be(false)
      end
    end
  end
end
