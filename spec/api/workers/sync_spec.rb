describe API::Workers::Sync do
  let(:params) do
    {
      'username' => 'mock_username',
      'password' => 'mock_password',
    }
  end

  let(:pkts)        { [1, 2, 3] }
  let(:last_sync_ptrs) { {} }
  let(:user_id)        { 3 }
  let(:date)           { DateTime.now }

  let(:mock_uri)  { 'mockuri' }
  let(:mock_repo) { API::SqlRepo.new(mock_uri) }

  let(:mfp_sync)        { instance_double(MFP::Sync, all_packets: pkts, last_sync_pointers: last_sync_ptrs) }
  let(:mfp_sync_klass)  { class_double(MFP::Sync, new: mfp_sync) }
  let(:sync_klass)      { class_double(API::Builders::Sync, call: nil)  }
  let(:last_sync_klass) { class_double(API::Builders::LastSyncInfo, call: nil) }

  before do
    allow(Sequel)
      .to receive(:connect)
      .and_return(Sequel.mock(host: 'postgres'))

    stub_const('DateTime', class_double(DateTime, now: date))
    stub_const('MFP::Sync', mfp_sync_klass)
    stub_const('API::Builders::Sync', sync_klass)
    stub_const('API::Builders::LastSyncInfo', last_sync_klass)
  end

  it 'initializes a new MFP::Sync' do
    Sidekiq::Testing.inline! do
      expect(mfp_sync_klass)
        .to receive(:new)
        .with(params.fetch('username'), params.fetch('password'))

      described_class.perform_async(params, user_id, mock_uri)
    end
  end

  it 'calls #all_packets on MFP::Sync' do
    Sidekiq::Testing.inline! do
      expect(mfp_sync)
        .to receive(:all_packets).once
        .and_return(pkts)

      described_class.perform_async(params, user_id, mock_uri)
    end
  end

  it 'calls Builders::Sync to save the packets' do
    Sidekiq::Testing.inline! do
      expect(sync_klass)
        .to receive(:call)
        .with(pkts.reverse, user_id, mock_repo)

      described_class.perform_async(params, user_id, mock_uri)
    end
  end

  it 'calls Builders::LastSyncInfo to save last sync pointers' do
    last_sync_klass
    Sidekiq::Testing.inline! do
      expect(last_sync_klass)
        .to receive(:call)
        .with({ user_id: user_id, date: date, ptrs: last_sync_ptrs }, mock_repo)

      described_class.perform_async(params, user_id, mock_uri)
    end
  end

  it 'fails when API::Workers::Base::SIDEKIQ_REPO is not set' do
    last_sync_klass
    Sidekiq::Testing.inline! do
      expect { described_class.perform_async(params, user_id) }
        .to raise_error(NameError)
    end
  end
end
