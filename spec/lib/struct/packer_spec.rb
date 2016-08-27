describe MFP::Struct::Packer do
  let(:extended_class) do
    class Class
      extend MFP::Struct::Packer
    end
  end

  describe '.pack_short' do
    let(:val) { 3 }

    it "packs the string into MyFitnessPal's proprietary binary format" do
      expect(extended_class.pack_short(val)).to eq "\x00\x03"
    end
  end

  describe '.pack_long' do
    let(:val) { 103 }

    it "packs the string into MyFitnessPal's proprietary binary format" do
      expect(extended_class.pack_long(val)).to eq "\x00\x00\x00g"
    end
  end

  describe '.pack_string' do
    let(:str) { 'foobar' }

    it "packs the string into MyFitnessPal's proprietary binary format" do
      expect(extended_class.pack_string(str)).to eq "\x00\x06foobar"
    end
  end

  describe '.pack_hash' do
    it 'packs string values' do
      expect(extended_class.pack_hash(2 => 'foobar'))
        .to eql("\x00\x01\x00\x02\x00\x06foobar".b)
    end
  end
end
