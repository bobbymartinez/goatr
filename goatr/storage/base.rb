module Goatr
  module Storage
    class Base
      def client
        Redis.new(url:ENV['REDIS_URL'])
      end

      def flush
        client.del(*client.keys("#{cache_key_prefix}*"))
      end

      def clear(id)
        client.del("#{cache_key_prefix}#{id}")
      end
    end
  end
end
