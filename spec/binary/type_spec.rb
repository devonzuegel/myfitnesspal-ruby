require 'bundler/setup'
require 'rspec'

require 'binary/type'
require 'binary/sync_request'
require 'binary/sync_response'
require 'binary/user_property_update'
require 'binary/measurement_types'
require 'binary/food'
require 'binary/meal_ingredients'

RSpec.describe Binary::Type do


  describe '#supported_types' do
    it 'should support the expected types' do
      expect(Binary::Type.supported_types).to eq(
        Binary::Type::SYNC_REQUEST          => Binary::SyncRequest,
        Binary::Type::SYNC_RESPONSE         => Binary::SyncResponse,
        Binary::Type::USER_PROPERTY_UPDATE  => Binary::UserPropertyUpdate,
        Binary::Type::MEASUREMENT_TYPES     => Binary::MeasurementTypes,
        Binary::Type::FOOD                  => Binary::Food,
        Binary::Type::MEAL_INGREDIENTS      => Binary::MealIngredients,
      )
    end

    it 'supports all types'
  end
end