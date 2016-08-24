module API
  module Routes
    class Users < Routes::Base
      get '/users/create' do
        validation = Schema::User::Creation.call(params.symbolize_keys)
        if validation.success?
          # # TODO: create user from passed-in repo
          # result = Repo::User.new(...).create(validation.output)
          # # TODO: check MFP login
          json(validation.output)
        else
          json(errors: validation.messages)
        end
      end
    end
  end
end
