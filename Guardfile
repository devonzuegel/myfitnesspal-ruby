command = 'bundle exec rspec --format documentation --color --require spec_helper'

guard :rspec, cmd: command do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^api/(.+)\.rb$}) { |m| "spec/api/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
end
