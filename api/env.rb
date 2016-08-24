module API
  class Env
    include Anima.new(:repository)

    attr_reader :repository

    def to_h
      {
        repository: repository.to_s
      }
    end
  end
end
