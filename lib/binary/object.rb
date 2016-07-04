require 'bundler/setup'
require 'abstract_method'

module Binary
  # Base class for `Codec` encodable objects. `Binary::Object`s do not have a
  # packet header.
  class Object
    abstract_method :set_default_values
    abstract_method :read_body_from_codec
    abstract_method :write_body_to_codec
    abstract_method :repr
  end
end