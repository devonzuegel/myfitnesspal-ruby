describe API::Services::UserSignup, :mock_db do
  include API::Builders::Utils

  let(:params) { { password: 'password', username: 'username' } }

  before do
    fake_sync_instance = instance_double(MFP::Sync, all_packets: [])
    stub_const('MFP::Sync', class_double(MFP::Sync, new: fake_sync_instance))
    stub_const('API::Builders::Sync', class_double(API::Builders::Sync, call: nil))
  end

  context 'user built successfully' do
    let(:stubbed_user) { params.merge(id: 2) }

    before do
      stub_const('API::Builders::User', class_double(API::Builders::User, call: stubbed_user))
    end

    it 'builds a user' do
      expect(API::Builders::User).to receive(:call).with(params, repository)
      described_class.call(params, repository)
    end

    it 'builds a user from stringy params' do
      expect(API::Builders::User).to receive(:call).with(params, repository)
      described_class.call(stringify_keys(params), repository)
    end

    it 'returns the created user' do
      expect(described_class.call(params, repository)).to eql stubbed_user
    end

    it 'persists the retrieved packets' do
      expected_args = [{'password'=>'password', 'username'=>'username'}, 'mockuri', 2]
      expect { described_class.call(params, repository) }
        .to change { Sidekiq::Queues['default'].map { |q| q['args'] } }
        .from([])
        .to([expected_args])
    end
  end

  context 'user built unsuccessfully' do
    let(:build_user_error) { { errors: 'blah blah blah' } }

    before do
      user_builder = class_double(API::Builders::User, call: build_user_error)
      stub_const('API::Builders::User', user_builder)
    end

    it 'returns the user creation errors' do
      expect(described_class.call(params, repository)).to eql build_user_error
    end

    it 'does not retrieve the packets with MFP::Sync' do
      expect(MFP::Sync).to receive(:new).exactly(0).times
      described_class.call(params, repository)
    end

    it 'does not persist the retrieved packets' do

      expect(API::Builders::Sync).to receive(:call).exactly(0).times
      described_class.call(params, repository)
    end
  end
end
