module API
  class Env
    include Anima.new(:repository)

    attr_reader :repository
  end
end
