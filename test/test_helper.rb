require "minitest/autorun"
require "minitest/spec"
require "minitest/mock"
require "rack/test"
require 'dotenv'

require "sidekiq"
require "sidekiq-queue-stats"
require "sidekiq/processor"
require "sidekiq/fetch"
require "sidekiq/cli"
Dotenv.load

Sidekiq.logger.level = Logger::ERROR

redis_url = ENV['REDIS_URL'] ? ENV['REDIS_URL'] : "redis://localhost/15"
REDIS = Sidekiq::RedisConnection.create(url: redis_url)
