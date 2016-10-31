describe API::Schema::LastSyncInfo do
  let(:valid_ptrs) do
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

  let(:valid_input) do
    {
      user_id: 1,
      ptrs:    valid_ptrs,
      date:    DateTime.now,
    }
  end

  describe 'API::Schema::LastSyncInfo::Pointers' do
    context 'valid pointers' do
      let(:result) { described_class::Pointers.call(valid_ptrs) }

      it 'is successful' do
        expect(result.success?).to be(true)
      end

      it 'has no messages' do
        expect(result.messages).to eql({})
      end

      it 'has the expected output' do
        expect(result.output).to eql(valid_ptrs)
      end
    end

    context 'invalid pointers' do
      let(:required_date_keys) do
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
        valid_ptrs.reject { |k, _v| k == key_to_remove }
      end

      it 'requires all keys' do
        required_date_keys.each do |key|
          input = without(valid_ptrs, key)
          expect(described_class::Pointers.call(input).success?).to be(false)
        end
      end

      it 'requires keys to be of expected types' do
        required_date_keys.each do |key|
          input = valid_ptrs.merge(key => 123)
          expect(described_class::Pointers.call(input).success?).to be(false)
        end
      end
    end
  end

  describe described_class::Creation do
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
      let(:int_keys)  { %i[user_id] }
      let(:required)  { date_keys + int_keys + %i[ptrs] }

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

      it 'requires keys to be of expected types' do
        date_keys.each do |key|
          input = valid_input.merge(key => 123123)
          expect(described_class.call(input).success?).to be(false)
        end

        int_keys.each do |key|
          input = valid_input.merge(key => 'xxx')
          expect(described_class.call(input).success?).to be(false)
        end
      end
    end
  end
end
