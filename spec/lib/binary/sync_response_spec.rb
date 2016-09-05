# require 'support/mocks/fake_codec'

describe MFP::Binary::SyncResponse do
  let(:sync_res) { described_class.new }

  describe '#to_h' do
    it 'serializes the starting attributes' do
      expect(sync_res.to_h).to eql(
        error_message:          '',
        expected_packet_count:  0,
        flags:                  0,
        last_sync_pointers:     {},
        master_id:              0,
        more_data_to_sync:      1,
        optional_extra_message: '',
        packet_type:            2,
        status_code:            0,
        status_message:         'Authenticated successfully',
        upgrade_alert:          nil,
        upgrade_available:      2,
        upgrade_url:            nil
      )
    end
  end
end
