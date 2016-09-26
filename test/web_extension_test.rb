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

    it 'can display home with worker stats tab' do
      get '/'

      last_response.status.must_equal 200
      last_response.body.must_match /Sidekiq/
      last_response.body.must_match /Worker Stats/
    end

    it 'can display worker stats page without any failures' do
      get '/worker_stats'
      last_response.status.must_equal 200
      last_response.body.must_match /Worker Stats/
      last_response.body.must_match /Default/
    end
  end
end
