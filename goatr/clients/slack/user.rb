module Goatr
  module Clients
    module Slack
      class User
        attr_accessor :client

        def initialize
          @client = ::Slack::Web::Client.new
        end

        def self.by_id(id)
          user = new.client.users_info(user: id)
          if user['ok']
            user['user']
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
