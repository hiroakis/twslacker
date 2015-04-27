require 'slack-notifier'

module Twslacker
  class SlackClient
    def initialize(webhook_url, channel, username, icon_emoji = "ghost", icon_url=nil)
      @icon_url = icon_url
      @icon_emoji = ":#{icon_emoji}:"
      @notifier = Slack::Notifier.new(webhook_url, channel: "##{channel}", username: username)
    end

    def post(message)
      if @icon_url
        @notifier.ping(message, icon_url: @icon_url)
      else
        @notifier.ping(message, icon_emoji: @icon_emoji)
      end
    end
  end
end