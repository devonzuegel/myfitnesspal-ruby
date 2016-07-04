require 'bundler/setup'
require 'abstract_method'
require 'json'

module Binary
  # Base class for `Codec` encodable objects. `Binary::Object`s do not have a
  # packet header.
  class Object
    abstract_method :set_default_values
    abstract_method :read_body_from_codec
    abstract_method :write_body_to_codec

    def initialize
      set_default_values
    end

    def to_json
      attributes.to_json
    end

    private

    def attributes
      Hash[instance_variables.map { |name| attr_val_pair(name) }]
    end

    def attr_val_pair(name)
      [name.to_s, instance_variable_get(name)]
    end
  end
end
