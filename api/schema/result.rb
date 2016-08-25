module API
  module Schema
    class Result
      include Concord.new(:messages)

      attr_reader :messages

      def success?
        messages.empty?
      end
    end
  end
end
