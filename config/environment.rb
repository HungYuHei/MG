# coding: utf-8
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
RubyChina::Application.initialize!

SITE_NAME = Setting.app_name

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # We're in smart spawning mode.
    if forked
      # Re-establish redis connection
      require 'redis'
      redis_config = YAML.load_file("#{Rails.root.to_s}/config/redis.yml")[Rails.env]

      # The important two lines
      $redis.client.disconnect
      $redis = Redis.new(:host => redis_config['host'], :port => redis_config['port'], :db => redis_config['db'])
    end
  end
end
