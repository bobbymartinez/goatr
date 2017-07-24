require 'goatr/storage/base'

module Goatr
  module Storage
    class User < Base
      def fetch(id) 
        u = JSON.parse(client.get("#{cache_key_prefix}#{id}"))
        if DateTime.parse(u['expires_at']) > DateTime.current
          u['user']
        else
          clear(id)
          nil
        end
      rescue => e
        clear(id)
        nil
      end

      def save(id, user)
        client.set("#{cache_key_prefix}#{id}", {
          user: user
        }.to_json)
      end

      private

      def cache_key_prefix
        'user-'
      end
    end
  end
end
