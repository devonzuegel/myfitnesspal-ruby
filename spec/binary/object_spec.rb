require 'bundler/setup'
require 'rspec'
require 'colorize'

require 'binary/object'

RSpec.describe Binary::Object do
  let(:obj) { Binary::Object.new }

  describe '#new' do
    it 'should raise an AbstractMethodCalled error' do
      expect { obj }.to raise_error AbstractMethodCalled
    end
  end

  describe '#set_default_values' do
    it 'should be an abstract method' do
      expect { obj.set_default_values }.to raise_error AbstractMethodCalled
    end
  end

  describe '#read_body_from_codec' do
    it 'should be an abstract method' do
      expect { obj.read_body_from_codec }.to raise_error AbstractMethodCalled
    end
  end

  describe '#write_body_to_codec' do
    it 'should be an abstract method' do
      expect { obj.write_body_to_codec }.to raise_error AbstractMethodCalled
    end
  end

  describe '#to_json' do
    it 'should be an abstract method' do
      expect { obj.to_json }.to raise_error AbstractMethodCalled
    end
  end
end
