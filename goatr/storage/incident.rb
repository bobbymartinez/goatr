require 'goatr/storage/base'

module Goatr
  module Storage
    class Incident < Base
      def fetch(id)
        #get key entry for incident and JSON parse
        #return nil if nothing found
        u = JSON.parse(client.get("#{cache_key_prefix}#{id}"))

        if (u['incident'] and !u['user'].empty?)
          u['incident']
        else
          nil
        end
      end

      def save(id, incident)
        client.set("#{cache_key_prefix}#{id}", {
          incident: incident
        }.to_json)
      end

      def get_incident_commander
        ic = client.get("#{cache_key_prefix}#{id}-ic")    
      end

      private

      def cache_key_prefix
        'incident-'
      end
    end
  end
end
