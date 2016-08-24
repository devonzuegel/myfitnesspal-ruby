module API
  class SqlRepo
    include Concord.new(:uri)

    attr_reader :uri

    def initialize(uri)
      super(uri)
      ROM.container(config)
    end

    def db
      Sequel.connect(uri)
    end

    def to_s
      uri
    end

    private

    def config
      ROM::Configuration.new(:sql, db)
    end
  end
end
