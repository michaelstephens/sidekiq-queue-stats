require "minitest/autorun"
require "minitest/spec"
require "minitest/mock"
require "rack/test"

require "sidekiq"
require "sidekiq-worker-stats"
require "sidekiq/processor"
require "sidekiq/fetch"
require "sidekiq/cli"

Sidekiq.logger.level = Logger::ERROR

REDIS = Sidekiq::RedisConnection.create(url: "redis://localhost/15")
