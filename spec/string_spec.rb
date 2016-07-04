require 'bundler/setup'
require 'rspec'
require 'colorize'

require 'binary/object'
require 'string'

RSpec.describe Binary::Object do
  describe '#snakecase' do
    it 'should underscore camelcase' do
      expect('HelloWorld'.snakecase).to eq 'hello_world'
    end

    it 'should underscore spaced words' do
      expect('hello world'.snakecase).to eq 'hello world'
    end
  end
end
