require 'securerandom'

username          = ENV['MYFITNESSPAL_USERNAME']
password          = ENV['MYFITNESSPAL_PASSWORD']
installation_uuid = SecureRandom.uuid

p installation_uuid