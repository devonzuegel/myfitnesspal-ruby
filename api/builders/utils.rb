module API
  module Builders
    module Utils
      def symbolize_keys(myhash)
        JSON.parse(JSON[myhash], symbolize_names: true)
      end

      def stringify_keys(myhash)
        JSON.parse(JSON[myhash])
      end
    end
  end
end
