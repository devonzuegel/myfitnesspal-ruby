module DB
  class Setup
    include Procto.call, Concord.new(:db_connection_str, :version)

    DB_ROOT = Pathname.new(__FILE__).parent

    def initialize(db_connection_str, version)
      super(db_connection_str, parsed_version(version))
    end

    def call
      db = Sequel.connect(db_connection_str)
      Sequel::Migrator.apply(db, DB_ROOT.join('migrate'), version)
    end

    def parsed_version(v)
      v.nil? ? nil : v.to_i
    end
  end
end
