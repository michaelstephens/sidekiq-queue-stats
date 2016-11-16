module Sidekiq
  module QueueStats
    class Configuration
      attr_accessor :max_limit

      def initialize
        @max_limit = nil
      end
    end
  end
end
