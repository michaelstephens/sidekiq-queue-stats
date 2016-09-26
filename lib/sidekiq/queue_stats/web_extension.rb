module Sidekiq
module QueueStats
    module WebExtension

      def self.registered(app)
        view_path = File.join(File.expand_path("..", __FILE__), "views")

        app.get "/queue_stats" do
          @queues = Sidekiq::Queue.all.map(&:name)
          @workers = {}

          if params[:queue] == "all"
            Sidekiq::Queue.all.each do |q|
              @workers[q.name] = {}
              total = q.map{|cue| cue.klass}
              klasses = total.uniq
              klasses.each do |klass|
                @workers[q.name][klass] = total.count(klass)
              end
            end
          else
            @queue = params[:queue] ? Sidekiq::Queue.new(params[:queue]) : Sidekiq::Queue.new
            @workers[@queue.name] = {}
            total = @queue.map{|cue| cue.klass}
            klasses = total.uniq
            if klasses
              klasses.each do |klass|
                @workers[@queue.name][klass] = total.count(klass)
              end
            end
          end

          render(:erb, File.read(File.join(view_path, "queue_stats.erb")))
        end
      end
    end
  end
end
