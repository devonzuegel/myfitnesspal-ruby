module API
  class SqlRepo
    extend Forwardable

    include Concord.new(:uri), Memoizable

    attr_reader :uri

    def_delegators :container, *%i[gateways relations relation unique?]

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
    memoize :container
  end
end
