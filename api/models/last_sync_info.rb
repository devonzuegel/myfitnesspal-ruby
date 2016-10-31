module API
  module Models
    class LastSyncInfo
      include Anima.new(
        :id,
        :user_id,
        :serialized_ptrs,
        :date,
      )
    end
  end
end
