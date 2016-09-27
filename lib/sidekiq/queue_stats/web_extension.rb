module Sidekiq
module QueueStats
    module WebExtension

      def self.registered(app)
        view_path = File.join(File.expand_path("..", __FILE__), "views")

        app.get "/queue_stats" do
          @queues = Sidekiq::Queue.all.map(&:name)
          @workers = {}

          if params[:queue]
            @queue = params[:queue] ? Sidekiq::Queue.new(params[:queue]) : Sidekiq::Queue.new
            @workers[@queue.name] = Hash.new(0)
            @queue.each do |job|
              @workers[@queue.name][job.klass] += 1
            end
          else
            Sidekiq::Queue.all.each do |q|
              @workers[q.name] = Hash.new(0)
              q.each do |job|
                @workers[q.name][job.klass] += 1
              end
            end
          end

          render(:erb, File.read(File.join(view_path, "queue_stats.erb")))
        end
      end
    end
  end
end
