require 'bundler/setup'
require 'rspec'
require 'colorize'

require 'binary/object'

RSpec.describe Binary::Object do
  let(:obj) { Binary::Object.new }

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

  describe '#repr' do
    it 'should be an abstract method' do
      expect { obj.repr }.to raise_error AbstractMethodCalled
    end
  end
end
