module API
  module Workers
    class Base
      private

      def repo(repo_uri = nil)
        if repo_uri.nil?
          SIDEKIQ_REPO
        else
          API::SqlRepo.new(repo_uri)
        end
      end
    end
  end
end
