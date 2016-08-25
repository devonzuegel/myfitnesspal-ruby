module API
  class SqlRepo
    extend Forwardable

    include Concord.new(:uri)

    attr_reader :uri

    def_delegator :container, :relation
    def_delegator :container, :unique?

    def initialize(uri)
      super(uri)
      container
    end

    def db
      Sequel.connect(uri)
    end

    def to_s
      uri
    end

    private

    def container
      config = ROM::Configuration.new(:sql, db)
      ROM.container(config)
    end
  end
end
