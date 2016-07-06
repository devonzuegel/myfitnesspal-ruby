command = 'bundle exec rspec --format Fuubar --color --require spec_helper'

guard :rspec, cmd: command do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
end
