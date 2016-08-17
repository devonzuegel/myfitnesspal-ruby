module API
  module Schema
    User =
      Dry::Validation.Schema do
        required(:username).filled(:str?)
        required(:password).filled(:str?)
      end
  end
end
