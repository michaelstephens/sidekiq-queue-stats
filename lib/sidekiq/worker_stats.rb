begin
  require "sidekiq/web"
rescue LoadError
  # client-only usage
end

require "sidekiq/api"
require "sidekiq/worker_stats/version"
require "sidekiq/worker_stats/web_extension"

module Sidekiq
end

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::WorkerStats::WebExtension
  Sidekiq::Web.tabs["Worker Stats"] = "worker_stats"
end
