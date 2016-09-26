# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sidekiq/worker_count/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Stephens"]
  gem.email         = ["michael@stephens.tech"]
  gem.description   = %q{Keep track of Sidekiq Worker stats}
  gem.summary       = %q{Keeps track of Sidekiq Worker stats to see total counts of each worker in each queue.}
  gem.homepage      = "https://github.com/mikestephens/sidekiq-worker-count/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sidekiq-worker-count"
  gem.require_paths = ["lib"]
  gem.version       = Sidekiq::Failures::VERSION

  gem.add_dependency "sidekiq", ">= 2.16.0"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "sprockets"
  gem.add_development_dependency "sinatra"
end
