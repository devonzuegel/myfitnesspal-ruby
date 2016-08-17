module API
  module Schema
    User =
      Dry::Validation.Schema do
        required(:username).filled(:str?, size?: 4..30)
        required(:password).filled(:str?, size?: 6..255)
      end
  end
end
