require 'bundler/setup'
require 'abstract_method'

module Binary
  # Base class for `Codec` encodable objects. `Binary::Object`s do not have a
  # packet header.
  class Object
    abstract_method :set_default_values
    abstract_method :read_body_from_codec
    abstract_method :write_body_to_codec

    ATTR_NAMES = nil

    def to_json
      fail NotImplementedError if ATTR_NAMES.nil?

      attributes.to_json
    end

    private

    def attributes
      Hash[instance_variables.map { |name| attr_val_pair(name) }]
    end

    def attr_val_pair(name)
      [name, instance_variable_get(name)]
    end
  end
end
