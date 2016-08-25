module API
  module Utils
    def symbolize_keys(myhash)
      Hash[myhash.map { |k, v| [k.to_sym, v] }]
    end
  end
end
