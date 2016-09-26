begin
  require "sidekiq/web"
rescue LoadError
  # client-only usage
end

require "sidekiq/api"
require "sidekiq/queue_stats/version"
require "sidekiq/queue_stats/web_extension"

module Sidekiq
end

if defined?(Sidekiq::Web)
  Sidekiq::Web.register Sidekiq::QueueStats::WebExtension
  Sidekiq::Web.tabs["Worker Stats"] = "queue_stats"
end
