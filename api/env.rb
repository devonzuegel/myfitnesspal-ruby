module API
  class Env
    include Anima.new(:repository, :secret, :rack_env)

    attr_reader :repository, :secret, :rack_env

    def to_h
      {
        repository: repository.to_s
      }
    end
  end
end
