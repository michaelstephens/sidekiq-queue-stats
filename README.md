# Sidekiq::WorkerCount [![Build Status](https://secure.travis-ci.org/mhfs/sidekiq-worker-count.png)](http://travis-ci.org/mhfs/sidekiq-worker-count)

Keeps track of Sidekiq failed jobs and adds a tab to the Web UI to let you browse
them. Makes use of Sidekiq's custom tabs and middleware chain.

It mimics the way Resque keeps track of worker-count.

WARNING: by default sidekiq-worker-count will keep up to 1000 worker-count. See [Maximum Tracked Failures](https://github.com/mhfs/sidekiq-worker-count#maximum-tracked-worker-count) below.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-worker-count'
```

## Usage

Simply having the gem in your Gemfile is enough to get you started. Your failed
jobs will be visible via a Failures tab in the Web UI.

## Configuring

### Maximum Tracked Failures

Since each failed job/retry creates a new failure entry that will only be removed
by you manually, your worker-count list might consume more resources than you have
available.

To avoid this sidekiq-worker-count adopts a default of 1000 maximum tracked worker-count.

To change the maximum amount:

```ruby
Sidekiq.configure_server do |config|
  config.worker-count_max_count = 5000
end
```

To disable the limit entirely:

```ruby
Sidekiq.configure_server do |config|
  config.worker-count_max_count = false
end
```

### Failures Tracking Mode

Sidekiq-worker-count offers three worker-count tracking options (per worker):


#### :all (default)

Tracks worker-count every time a background job fails. This mean a job with 25 retries
enabled might generate up to 25 failure entries. If the worker has retry disabled
only one failure will be tracked.

This is the default behavior but can be made explicit with:

```ruby
class MyWorker
  include Sidekiq::Worker

  sidekiq_options :worker-count => true # or :all

  def perform; end
end
```

#### :exhausted

Only track worker-count if the job exhausts all its retries (or doesn't have retries
enabled).

You can set this mode as follows:

```ruby
class MyWorker
  include Sidekiq::Worker

  sidekiq_options :worker-count => :exhausted

  def perform; end
end
```

#### :off

You can also completely turn off worker-count tracking for a given worker as follows:

```ruby
class MyWorker
  include Sidekiq::Worker

  sidekiq_options :worker-count => false # or :off

  def perform; end
end
```

#### Change the default mode

You can also change the default of all your workers at once by setting the following
server config:

```ruby
Sidekiq.configure_server do |config|
  config.worker-count_default_mode = :off
end
```

The valid modes are `:all`, `:exhausted` or `:off`.

## Helper Methods

### Failures Count

Gives back the number of failed jobs currently stored in Sidekiq Failures. Notice that it's
different from `Sidekiq` built in failed stat. Also, notice that this might be
influenced by `worker-count_max_count`.

```ruby
Sidekiq::Failures.count
```

### Reset Failures

Gives a convenient way of reseting Sidekiq Failure stored failed jobs programmatically.
Takes an options hash and if the `counter` key is present also resets Sidekiq own failed stats.

```ruby
Sidekiq::Failures.reset_worker-count
```

## Dependencies

Depends on Sidekiq >= 2.16.0

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Released under the MIT License. See the [LICENSE][license] file for further details.

[license]: https://github.com/mhfs/sidekiq-worker-count/blob/master/LICENSE
