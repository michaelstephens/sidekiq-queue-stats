begin
  require "sidekiq/web"
rescue LoadError
  # client-only usage
end

require "sidekiq/api"
require "sidekiq/worker_count/version"
require "sidekiq/worker_count/middleware"
require "sidekiq/worker_count/web_extension"

module Sidekiq
end

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::WorkerStats::WebExtension
  Sidekiq::Web.tabs["Worker Count"] = "worker_count"
end
