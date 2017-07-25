require 'goatr/storage/base'

module Goatr
  module Storage
    class Incident < Base
      def new_incident(incident={})
        begin
          id = redis.incr("cache_key_prefix")
          save_incident(id,incident)
        rescue => e
          nil
        end
      end

      def get_incident(id)
        begin
          incident = JSON.parse(client.get("#{cache_key_prefix}#{id}"))
        rescue => e
          nil
        end
      end

      def save_incident(id,incident)
        raise "InvalidJson" unless JSON.parse(incident.to_json)
        begin
          client.set("#{cache_key_prefix}#{id}"),
          incident.to_json)
        rescue => e
          nil
        end
        incident.to_json
      end

      private

      def cache_key_prefix
        'incident-'
      end
    end
  end
end
