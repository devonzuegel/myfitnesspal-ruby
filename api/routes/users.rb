require_relative 'base'

module API
  module Routes
    class Users < Routes::Base
      get '/users/create' do
        validation =
          Schema::User::Creation.call(
            symbolize_keys(params),
            Repo::User.new(app_env.repository)
          )

        if validation.success?
          Repo::User.new(app_env.repository).create(validation.output)
          json(validation.output)
        else
          json(errors: validation.messages)
        end
      end
    end
  end
end
