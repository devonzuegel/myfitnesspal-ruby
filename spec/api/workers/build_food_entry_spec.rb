describe API::Workers::BuildFoodEntry do
  let(:hash_packet)       { {} }
  let(:mock_uri)          { 'mockuri' }
  let(:user_id)           { 3 }
  let(:food_orchestrator) { class_double(API::Builders::FoodOrchestrator, call: nil) }
  let(:args)              { [hash_packet, mock_uri, user_id] }

  before do
    allow(Sequel)
      .to receive(:connect)
      .and_return(Sequel.mock(host: 'postgres'))

    stub_const('API::Builders::FoodOrchestrator', food_orchestrator)
  end

  it 'calls the food orchestrator' do
    Sidekiq::Testing.inline! do
      expect(food_orchestrator)
        .to receive(:call)
        .with(hash_packet, API::SqlRepo.new(mock_uri), user_id)

      described_class.perform_async(hash_packet, user_id, mock_uri)
    end
  end
end