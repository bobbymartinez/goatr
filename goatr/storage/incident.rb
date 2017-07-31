require 'goatr/storage/base'

module Goatr
  module Storage
    class Incident < Base
      @@id_counter = "incident_id_counter"

      def new_incident
        begin
          puts "incrementing incident count"
          id = client.incr(@@id_counter)
          puts "new on incident #{id}"
          incident = {"id" => id}
          save_incident(id,incident)
        rescue => e
          puts "could not create incident: #{e.to_json}"
          nil
        end
      end

      def get_incident(id)
        begin
          incident = JSON.parse(client.get("#{cache_key_prefix}#{id}"))
        rescue => e
          puts e.to_json
          nil
        end
      end

      def get_incident_id_by_channel_id(channel_id)
        client.get("#{cache_key_prefix}channel-#{channel_id}")
      end

      def get_incidents
        begin
          incident_keys = client.keys("#{cache_key_prefix}*")
          incidents = []
          incident_keys.each do |key|
            incidents << JSON.parse(client.get(key))
          end
        rescue => e
          puts e.to_json
          nil
        end
        incidents
      end

      def save_incident(id,incident)
        raise "InvalidJson" unless JSON.parse(incident.to_json)
        begin
          client.set("#{cache_key_prefix}#{id}",
          incident.to_json)
        rescue => e
          puts e.to_json
          nil
        end
        incident
      end

      #maps the slack channel id to
      def map_channel_to_incident(channel_id,incident_id)
        client.set("#{cache_key_prefix}channel-#{channel_id}",incident_id)
      end

      private

      def cache_key_prefix
        'incident-'
      end
    end
  end
end
