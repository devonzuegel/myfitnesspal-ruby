require 'support/mocks/packet_mocks/raw'

describe MFP::Struct::Reader do
  describe '#parse' do
    let(:extended_class) do
      class Class
        extend MFP::Struct::Reader
      end
    end

    let(:packed) do
      "\x00\x01\x00\x00\x00\x14JUNK".b
    end

    it 'reads the expected bytes from the given bytestring' do
      parsed, rest = extended_class.parse(packed, 2, 's>')
      expect(parsed).to be(1)
      expect(rest).to eql("\x00\x00\x00\x14JUNK".b)
    end

    it 'reads full string and does not return a remainder at the end of a parse' do
      parsed, rest = extended_class.parse("\x00\x01".b, 2, 's>')
      expect(parsed).to be(1)
      expect(rest).to eql('')
    end

    it 'raises an EOFError when num_bytes > the number of bytes' do
      expect { extended_class.parse(packed, 20, 's>') }.to raise_error EOFError
    end
  end

  # describe '#read_date' do
  #   it 'parses an iso8601 date' do
  #     expect(extended_class.read_date('1993-10-07JUNK')).to eql(Date.new(1993, 10, 7))
  #     expect(extended_class.remainder).to eql('JUNK')
  #   end
  # end
end
