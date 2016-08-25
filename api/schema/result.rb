module API
  module Schema
    class Result
      include Concord.new(:messages, :partial_output)

      attr_reader :messages

      def success?
        messages.empty?
      end

      def output
        if success?
          partial_output
        else
          {}
        end
      end
    end
  end
end
