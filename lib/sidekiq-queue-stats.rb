require "sidekiq/queue_stats"
require 'sidekiq/queue_stats/configuration'

module Sidekiq
  module QueueStats
    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
