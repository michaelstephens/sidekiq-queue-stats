require "test_helper"
require "sidekiq/web"

module Sidekiq
  describe "WebExtension" do
    include Rack::Test::Methods

    def app
      Sidekiq::Web
    end

    before do
      Sidekiq.redis = REDIS
      Sidekiq.redis {|c| c.flushdb }
    end

    it 'can display home with queue stats tab' do
      get '/'
      last_response.status.must_equal 200
      last_response.body.must_match /Sidekiq/
      last_response.body.must_match /Queue Stats/
    end

    it 'can display queue stats page without any failures' do
      get '/queue_stats'
      last_response.status.must_equal 200
      last_response.body.must_match /Queue Stats/
      last_response.body.must_match /Nothing waiting in any queue/
    end
  end
end
