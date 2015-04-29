require 'yaml'

module Twslacker
  class Base
    def initialize
      @options = {
        stream_type: "userstream",
        config_file: File.join(File.dirname(__FILE__), '../../.config.yml'),
        daemonized: false,
        pid: "./twslacker.pid",
        output: "slack"
      }
      optparse = OptionParser.new
      optparse.on("-t [STREAM_TYPE]", "--type [STREAM_TYPE]", "sample, track, follow or userstream.  default: userstream") do |t|
        @options[:stream_type] = t
      end
      optparse.on("-c [CONFIG_FILE_PATH]", "--config [CONFIG_FILE_PATH]", "config file path. default: .config.yml") do |file|
        @options[:config_file] = File.join(file)
      end
      optparse.on("-i=word,word,...", "--ignore=word,word,...", Array, "ignore words") do |words|
        @options[:ignore] = words
      end
      optparse.on("-d", "--daemonize", "daemonize flag. default: disable") do |daemon|
        @options[:daemonized] = daemon
      end
      optparse.on("-p [PID_FILE]", "--pid [PID_FILE]", "pid file.  default: ./twslacker.pid") do |pid_file|
        @options[:pid] = pid_file
      end
      optparse.on("-o [OUTPUT]", "--out [OUTPUT]" , "slack or stdout. default: slack") do |output|
        @options[:output] = output
      end
      optparse.parse!
    end

    def run
      begin
        daemonize(@options[:pid]) if @options[:daemonized]
      rescue Exception => e
        p e.message
        Kernel.exit(1)
      end
      signal
      setup

      notifier = get_notifier(@options[:output])
      ignore_words = @options[:ignore] || []
      case @options[:stream_type]
      when 'sample'
        @twitter_client.sample(ignore_words, &notifier)
      when 'track'
        @twitter_client.track(args, ignore_words, &notifier)
      when 'follow'
        @twitter_client.follow(args, ignore_words, &notifier)
      when 'userstream'
        @twitter_client.userstream(ignore_words, &notifier)
      end
    end

    def shutdown
      begin
        raise "pid file not found" unless File.exists?(@options[:pid])
        pid = File.open(@options[:pid])
        Process.kill(:INT, pid.read.to_i)
        File.delete(@options[:pid])
      rescue Exception => e
        p e.message
        Kernel.exit(1)
      end
    end

    private
    def setup
      if File.exists? @options[:config_file]
        configs = YAML.load_file(@options[:config_file])
      else
        puts "Config file not found"
        Kernel.exit(1)
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

    private
    def get_notifier(notifier)
      case notifier
      when 'slack'
        Proc.new { |message| @slack.post message }
      when 'stdout'
        Proc.new { |message| puts message }
      end
    end

    private
    def signal
      Signal.trap(:INT) { exit }
      Signal.trap(:TERM) { exit }
    end

    private
    def daemonize(file)
      begin
        raise "pid file already exists" if File.exists?(file)
        File.open(file, 'w') do |f|
          f.puts(Process.pid)
        end
        Process.daemon(true, true)
      rescue Exception => e
        raise
      end
    end
  end
end