module Goatr
  module Clients
    module Slack
      class Channel
        attr_accessor :client

        def initialize
          @client = ::Slack::Web::Client.new
        end

        def self.by_id(id)
          channel = new.client.channels_info(channel: id)
          if channel['ok']
            channel['channel']
          else
            nil
          end
        rescue ::Slack::Web::Api::Error => e
          nil
        end
      end
    end
  end
