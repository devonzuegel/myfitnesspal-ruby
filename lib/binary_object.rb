require 'abstract_method'

module Binary
  # Base class for `Codec` encodable objects. `Binary::Object`s do not have a
  # packet header.
  class Object
    abstract_method :set_default_values,
                    :read_body_from_codec,
                    :write_body_to_codec,
                    :repr

    def blah
      'BLAH BLAH BLAH'
    end
  end
end
