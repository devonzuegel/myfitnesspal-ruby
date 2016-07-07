module Binary
  # Module containing TYPE values for each BinaryPacket type.
  module Type
    SYNC_REQUEST               = 1
    SYNC_RESPONSE              = 2
    FOOD                       = 3
    EXERCISE                   = 4
    FOOD_ENTRY                 = 5
    EXERCISE_ENTRY             = 6
    CLIENT_FOOD_ENTRY          = 7
    CLIENT_EXERCISE_ENTRY      = 8
    MEASUREMENT_TYPES          = 9
    MEASUREMENT_VALUE          = 10
    MEAL_INGREDIENTS           = 11
    MASTER_ID_ASSIGNMENT       = 12
    USER_PROPERTY_UPDATE       = 13
    USER_REGISTRATION          = 14
    WATER_ENTRY                = 16
    DELETE_ITEM                = 17
    SEARCH_REQUEST             = 18
    SEARCH_RESPONSE            = 19
    FAILED_ITEM_CREATION       = 20
    ADD_DELETED_MOST_USED_FOOD = 21
    DIARY_NOTE                 = 23

    def self.supported_types
        type_name_pairs =
          [
            Binary::SyncRequest,
            Binary::SyncResponse,
            Binary::UserPropertyUpdate,
            Binary::MeasurementTypes,
          ].map { |klass| [klass::PACKET_TYPE, klass] }
        Hash[type_name_pairs]
    end
  end
end
