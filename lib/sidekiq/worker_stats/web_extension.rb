module Sidekiq
  module WorkerStats
    module WebExtension

      def self.registered(app)
        view_path = File.join(File.expand_path("..", __FILE__), "views")

        app.helpers do
          def safe_relative_time(time)
            time = if time.is_a?(Numeric)
              Time.at(time)
            else
              Time.parse(time)
            end

            relative_time(time)
          end
        end

        app.get "/worker_stats" do
          @queues = Sidekiq::Queue.all.map(&:name)
          @workers = {}
            Sidekiq::Queue.all.each do |q|
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
