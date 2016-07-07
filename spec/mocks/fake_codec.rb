# Mock for Codec
class FakeCodec
  def read_4_byte_int
    1
  end

  def read_2_byte_int
    1
  end

  def read_string
    'hello_world'
  end

  def read_uuid
    Binary::Packet.generate_uuid
  end

  def read_map(_int)
    {
      'key1' => 'value1',
      'key2' => 'value2'
    }
  end
end