$redis = Redis.new

url = ENV["REDISCLOUD_URL"]
# was rediscloud_url

if url
  Sidekiq.configure_server do |config|
    config.redis = { url: url }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: url }
  end
  $redis = Redis.new(:url => url)
end
