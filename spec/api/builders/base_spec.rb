describe API::Builders::Base do
  let(:raw_params)     { { 'key1' => 'blah', 'key2' => 'foobar' } }
  let(:params)         { { key1: 'blah', key2: 'foobar' } }
  let(:mapper)         { instance_double(API::Mappers::User) }

  context 'failed validation' do
    let(:failure_msgs)  { { message1: 'baz' } }
    let(:failed_val)    { API::Schema::Result.new(failure_msgs, params) }
    let(:validtn_klass) { class_double(API::Schema::User::Creation, call: failed_val) }

    it 'calls the provided validation & returns its errors' do
      expect(described_class.call(raw_params, validtn_klass, mapper))
        .to eql(errors: failure_msgs)
    end
  end

  context 'successful validation' do
    let(:successful_val) { API::Schema::Result.new({}, params) }
    let(:validtn_klass)  { class_double(API::Schema::Food::Creation, call: successful_val) }

    before do
      expect(validtn_klass).to receive(:call).with(params)
      expect(mapper).to receive(:create).with(params)
    end

    it 'calls the provided validation & returns its output upon success' do
      expect(described_class.call(raw_params, validtn_klass, mapper)).to eql(params)
    end

    it 'creates a new user with validation output upon success' do
      described_class.call(raw_params, validtn_klass, mapper)
    end
  end
end
