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

      def <<(other)
        new_messages = messages.merge(other.messages)
        self.class.new(new_messages, partial_output)
      end
    end
  end
end
