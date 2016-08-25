Dir.glob(Pathname.new('.').join('api', '**', '*.rb').expand_path) { |f| require f }

module API
  module Models
    autoload :User, 'models/user'
  end

  class App < Routes::Base
    use Routes::Users
  end
end
