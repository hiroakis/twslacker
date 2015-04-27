require 'twitter'
require 'tweetstream'

module Twslacker
  class TwitterClient
    def initialize(consumer_key, consumer_secret, access_token_key, access_secret)
      @rest_client = Twitter::REST::Client.new do |config|
        config.consumer_key        = consumer_key
        config.consumer_secret     = consumer_secret
        config.access_token        = access_token_key
        config.access_token_secret = access_secret
      end

      TweetStream.configure do |config|
        config.consumer_key        = consumer_key
        config.consumer_secret     = consumer_secret
        config.oauth_token         = access_token_key
        config.oauth_token_secret  = access_secret
        config.auth_method         = :oauth
      end
      @stream_client = TweetStream::Daemon.new('twslacker')
    end

    def sample(&block)
      @stream_client.sample do |status|
        yield "#{status.user.screen_name}: #{status.text}"
      end
    end

    def track(keywords, &block)
      @stream_client.track(keywords) do |status|
        yield "#{status.user.screen_name}: #{status.text}"
      end
    end

    def follow(screen_names, &block)
      ids = get_user_ids_from_screen_names(screen_names)
      @stream_client.follow(ids) do |status|
        yield "#{status.user.screen_name}: #{status.text}"
      end
    end

    def userstream(&block)
      @stream_client.userstream do |status|
        yield "#{status.user.screen_name}: #{status.text}"
      end
    end

    private
    def get_user_ids_from_screen_names(screen_names)
      @rest_client.friendships(screen_names).map {|user| user.id }
    end
  end
end