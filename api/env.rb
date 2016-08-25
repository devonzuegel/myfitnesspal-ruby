module API
  class Env
    include Anima.new(:repository, :secret, :rack_env)

    attr_reader :repository, :secret, :rack_env

    def to_h
      {
        repository: repository.to_s,
        secret:     secret,
        rack_env:   rack_env
      }
    end

    class Wrapper
      include Concord.new(:app_env)

      attr_reader :app_env
    end
  end
end
