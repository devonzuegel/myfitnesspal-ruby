module API
  module Routes
    class Users < Base
      get '/users' do
        json([])
        # json(::API::Models::User.all.map(&:to_hash))
      end

      get '/users/create' do
        json([])
        # json(::API::Models::User.create(username: 'devon', password: 'xxxxx').to_hash)
      end
    end
  end
end
