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
  end
end
