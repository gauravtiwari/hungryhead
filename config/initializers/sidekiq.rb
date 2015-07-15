Sidekiq.configure_server do |config|
  config.redis = { url: ENV["REDIS_URL"] || 'redis://127.0.0.1:6379' }
  ActiveRecord::Base.establish_connection
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV["REDIS_URL"] || 'redis://127.0.0.1:6379' }
  ActiveRecord::Base.establish_connection
end

Sidekiq.default_worker_options = {
   'unique' => true,
   'unique_args' => proc do |args|
     [args.first.except('job_id')]
   end
}
SidekiqUniqueJobs.config.unique_args_enabled = true