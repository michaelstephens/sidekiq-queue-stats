module Sidekiq
module QueueStats
    module WebExtension

      def self.registered(app)
        view_path = File.join(File.expand_path("..", __FILE__), "views")

        app.get "/queue_stats" do
          @queues_list = Sidekiq::Queue.all.map(&:name)
          @workers_count = {}

          if params[:selected_queue]
            @selected_queue = params[:selected_queue] ? Sidekiq::Queue.new(params[:selected_queue]) : Sidekiq::Queue.new
            @workers_count[@selected_queue.name] = Hash.new(0)
            @selected_queue.each do |job|
              @workers_count[@selected_queue.name][job.klass] += 1
            end
          else
            queues_list = Sidekiq::Queue.all
            queues_list.each do |q|
              if !Sidekiq::QueueStats.configuration.max_limit.nil? && q.size > Sidekiq::QueueStats.configuration.max_limit
                @workers_count[q.name] = "too_big"
              else
                @workers_count[q.name] = Hash.new(0)
                q.each do |job|
                  @workers_count[q.name][job.klass] += 1
                end
              end
            end
          end

          render(:erb, File.read(File.join(view_path, "queue_stats.erb")))
        end
      end
    end
  end
end
