module API
  module Routes
    class Users < Routes::Base
      get '/users' do
        json(Repo::User.new(app_env.repository).query({}).map &:to_h)
      end

      get '/users/create' do
        validation = Schema::User::Creation.call(symbolize_keys(params))
        if validation.success?
          Repo::User.new(app_env.repository).create(validation.output)
          # # TODO: check MFP login
          json(validation.output)
        else
          json(errors: validation.messages)
        end
      end
    end
  end
end
