describe MFP::Binary::Type do
  describe '#supported_types' do
    it 'supports the expected types' do
      expect(described_class.supported_types).to eq(
        MFP::Binary::Type::SYNC_REQUEST         => MFP::Binary::SyncRequest,
        MFP::Binary::Type::SYNC_RESPONSE        => MFP::Binary::SyncResponse,
        MFP::Binary::Type::USER_PROPERTY_UPDATE => MFP::Binary::UserPropertyUpdate,
        MFP::Binary::Type::MEASUREMENT_TYPES    => MFP::Binary::MeasurementTypes,
        MFP::Binary::Type::FOOD                 => MFP::Binary::Food,
        MFP::Binary::Type::MEAL_INGREDIENTS     => MFP::Binary::MealIngredients,
        MFP::Binary::Type::FOOD_ENTRY           => MFP::Binary::FoodEntry,
        MFP::Binary::Type::EXERCISE             => MFP::Binary::Exercise,
        MFP::Binary::Type::EXERCISE_ENTRY       => MFP::Binary::ExerciseEntry,
        MFP::Binary::Type::WATER_ENTRY          => MFP::Binary::WaterEntry,
        MFP::Binary::Type::MEASUREMENT_VALUE    => MFP::Binary::MeasurementValue,
        MFP::Binary::Type::DELETE_ITEM          => MFP::Binary::DeleteItem
      )
    end
  end
end
