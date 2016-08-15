module API
  module Routes
    class Users < Base
      get '/users' do
        json(Models::User.all)
      end
    end
  end
end
