module API
  module Mappers
    class LastSyncInfo < ROM::Repository[:last_sync_info]
      commands :create

      def query(conditions)
        last_sync_info
          .where(conditions)
          .as(Models::LastSyncInfo)
          .to_ary
      end
    end
  end
end
