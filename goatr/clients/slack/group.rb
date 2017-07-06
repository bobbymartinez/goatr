module Goatr
  module Clients
    module Slack
      class Group
        attr_accessor :client

        def initialize
          @client = ::Slack::Web::Client.new
        end

        ##
        # @param [String] id
        # @return [Hashie::Mash]
        #
        def self.by_id(id)
          channel = new.client.groups_info(channel: id)
          if channel['ok']
            Hashie::Mash.new(channel['group'])
          else
            nil
          end
        rescue ::Slack::Web::Api::Error => e
          nil
        end
      end
    end
  end
end
