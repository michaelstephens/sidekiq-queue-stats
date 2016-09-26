module Sidekiq
  module WorkerStats
    module WebExtension

      def self.registered(app)
        view_path = File.join(File.expand_path("..", __FILE__), "views")

        app.get "/worker_stats" do
          @queues = Sidekiq::Queue.all.map(&:name)
          @queue  = params[:queue] ? Sidekiq::Queue.new(params[:queue]) : Sidekiq::Queue.new
          @workers = {}
            @queue.each do |q|
              @workers[q.name] = {}
              total = q.map{|cue| cue.klass}
              klasses = total.uniq
              klasses.each do |klass|
                @workers[q.name][klass] = total.count(klass)
              end
            end

          render(:erb, File.read(File.join(view_path, "worker_stats.erb")))
        end
      end
    end
  end
end
