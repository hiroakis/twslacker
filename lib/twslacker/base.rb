require 'yaml'

module Twslacker
  class Base
    def initialize
      @options = {
        config_file: File.join(File.dirname(__FILE__), '../../.config.yml'),
      }
      optparse = OptionParser.new
      optparse.on("-t [STREAM_TYPE]", "--type [STREAM_TYPE]", "sample, track, follow or userstream") do |t|
        @options[:stream_type] = t
      end
      optparse.on("-c [CONFIG_FILE_PATH]", "--config [CONFIG_FILE_PATH]", "config file path") do |file|
        @options[:config_file] = File.join(file)
      end
      optparse.on("-i=word,word,...", "--ignore=word,word,...", Array, "ignore words") do |words|
        @options[:ignore] = words
      end
      optparse.parse!
    end

    def run(args={})
      setup

      callback = Proc.new do |message|
        @slack.post message
      end

      ignore_words = @options[:ignore] || []
      case @options[:stream_type]
      when 'sample'
        @twitter_client.sample(ignore_words, &callback)
      when 'track'
        @twitter_client.track(args, ignore_words, &callback)
      when 'follow'
        @twitter_client.follow(args, ignore_words, &callback)
      when 'userstream'
        @twitter_client.follow(ignore_words, &callback)
      else
      end
    end

    private
    def setup
      if File.exists? @options[:config_file]
        configs = YAML.load_file(@options[:config_file])
      else
        puts "Config file not found"
        exit 1
      end
      @slack = Twslacker::SlackClient.new(
        configs["slack"]["webhook_url"],
        configs["slack"]["channel"],
        configs["slack"]["username"],
        configs["slack"]["icon_emoji"]
      )
      @twitter_client = Twslacker::TwitterClient.new(
        configs["twitter"]["consumer_key"],
        configs["twitter"]["consumer_secret"],
        configs["twitter"]["access_token_key"],
        configs["twitter"]["access_secret"]
      )
    end
  end
end